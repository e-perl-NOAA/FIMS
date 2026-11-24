module FIMSBenchmarkProfiler

using FIMSBackend
using Profile

const state = Ref{Any}(nothing)

function compact_frames(frames)
  Dict(address => [
    Base.StackTraces.StackFrame(
      frame.func, frame.file, frame.line, nothing,
      frame.from_c, frame.inlined, frame.pointer,
    )
    for frame in stack
  ] for (address, stack) in frames)
end

function snapshot(stage; force = false, resume = true)
  current = state[]
  isnothing(current) && return nothing
  compilation = Base.cumulative_compile_time_ns()
  garbage_collection = Base.gc_num()
  open(joinpath(current.directory, "compilation.tsv"), "a") do io
    println(io, time(), '\t', stage, '\t',
      (compilation[1] - current.compilation[1]) / 1e9, '\t',
      (compilation[2] - current.compilation[2]) / 1e9, '\t',
      (garbage_collection.total_time - current.gc_time) / 1e9)
  end
  !force && time() - current.last[] < current.interval && return nothing
  started = time()
  Profile.stop_timer()
  try
    Profile.is_buffer_full() && error("Julia sampling buffer filled before a safe snapshot.")
    samples = Profile.fetch()
    current.count[] += 1
    name = "snapshot-" * lpad(string(current.count[]), 6, '0') * ".txt"
    path = joinpath(current.directory, name)
    open(path * ".tmp", "w") do io
      println(io, "epoch_seconds=", time(), " stage=", stage)
      if isempty(samples)
        println(io, "No samples collected in this window.")
      else
        # Rendering nested AD method signatures can take longer than sampling.
        frames = compact_frames(Profile.getdict(samples))
        Profile.print(IOContext(io, :displaysize => (100, 240)), samples, frames;
          format = :flat, sortedby = :count, C = true)
      end
    end
    mv(path * ".tmp", path; force = true)
    cp(path, joinpath(current.directory, "latest.txt"); force = true)
    elapsed = time() - started
    current.seconds[] += elapsed
    open(joinpath(current.directory, "snapshots.tsv"), "a") do io
      println(io, time(), '\t', name, '\t', stage, '\t', length(samples), '\t', elapsed)
    end
    Profile.clear()
    current.last[] = time()
  finally
    resume && Profile.start_timer()
  end
  nothing
end

function start(directory, interval)
  isnothing(state[]) && isnothing(FIMSBackend._optimizer_checkpoint_observer[]) ||
    error("An optimizer checkpoint observer is already registered.")
  try
    isfinite(interval) && interval > 0 || error("Snapshot interval must be positive and finite.")
    mkpath(directory)
    Base.cumulative_compile_timing(true)
    state[] = (
      directory = directory, interval = Float64(interval), last = Ref(0.0),
      count = Ref(0), seconds = Ref(0.0),
      compilation = Base.cumulative_compile_time_ns(), gc_time = Base.gc_num().total_time,
    )
    write(joinpath(directory, "snapshots.tsv"),
      "epoch_seconds\tfile\tstage\traw_entries\twrite_seconds\n")
    write(joinpath(directory, "compilation.tsv"),
      "epoch_seconds\tstage\tcompilation_seconds\trecompilation_seconds\tgc_seconds\n")
    Profile.clear()
    Profile.init(n = 10_000_000, delay = 0.1)
    # Snapshot on the optimizer's own task, never from an R background thread.
    FIMSBackend._optimizer_checkpoint_observer[] = stage -> snapshot(stage)
    snapshot("profile:start"; force = true)
  catch
    Profile.stop_timer()
    FIMSBackend._optimizer_checkpoint_observer[] = nothing
    state[] = nothing
    rethrow()
  end
  nothing
end

function finish()
  FIMSBackend._optimizer_checkpoint_observer[] = nothing
  try
    snapshot("profile:complete"; force = true, resume = false)
    current = state[]
    Dict("snapshots" => current.count[], "snapshot_write_seconds" => current.seconds[])
  finally
    Profile.stop_timer()
    state[] = nothing
  end
end

function layout(parameters, config)
  config = FIMSBackend.normalize_keys(config)
  values, _ = FIMSBackend._flatten_init_params(parameters, config)
  Dict(
    "values" => values,
    "fixed" => findall(Bool.(collect(config[:fixed_parameter_mask]))),
    "random" => findall(Bool.(collect(config[:random_parameter_mask]))),
  )
end

end
