using Test
using Profile
using FIMSBackend

include(joinpath(@__DIR__, "benchmark_profile.jl"))

@testset "compact live profiles preserve sampled frame identity" begin
  frame = Base.StackTraces.StackFrame(
    :profile_probe, Symbol("probe.jl"), 17, @__MODULE__, false, true, UInt64(123),
  )
  original = Dict(UInt(123) => [frame])
  compact = FIMSBenchmarkProfiler.compact_frames(original)
  @test compact[UInt(123)][1] == frame
  @test compact[UInt(123)][1].pointer == frame.pointer
  @test isnothing(compact[UInt(123)][1].linfo)
  @test original[UInt(123)][1].linfo === @__MODULE__
  @test isempty(FIMSBenchmarkProfiler.compact_frames(empty(original)))
end

@testset "live profiler restores state after success and failure" begin
  mktempdir() do directory
    mkdir(joinpath(directory, "snapshots.tsv"))
    @test_throws SystemError FIMSBenchmarkProfiler.start(directory, 30)
    @test isnothing(FIMSBenchmarkProfiler.state[])
    @test isnothing(FIMSBackend._optimizer_checkpoint_observer[])
  end
  mktempdir() do directory
    FIMSBenchmarkProfiler.start(directory, 30)
    try
      @test_throws ErrorException FIMSBenchmarkProfiler.start(directory, 30)
      Profile.@profile sum(sin, range(0.0, 1.0; length = 2_000_000))
      FIMSBenchmarkProfiler.snapshot("test:live"; force = true)
      @test isfile(joinpath(directory, "snapshot-000002.txt"))
      @test occursin("stage=test:live", read(joinpath(directory, "latest.txt"), String))
    finally
      result = FIMSBenchmarkProfiler.finish()
      @test result["snapshots"] == 3
      @test isnothing(FIMSBackend._optimizer_checkpoint_observer[])
      @test isnothing(FIMSBenchmarkProfiler.state[])
    end
  end
end
