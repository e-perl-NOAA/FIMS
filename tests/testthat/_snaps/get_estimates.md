# `get_estimates()` works with deterministic run

    Code
      estimates_snapshot <- dplyr::select(FIMS:::estimates_big_unoptimized,
      -estimated, -expected, -uncertainty, -gradient, -likelihood, -log_like_cv)
      estimates_snapshot_lines <- capture.output(print(estimates_snapshot, n = 320,
        width = Inf))
      cat(trimws(estimates_snapshot_lines, which = "right"), sep = "\n")
    Output
      # A tibble: 13,974 x 18
          module_name module_id module_type  label            type      type_id
          <chr>           <int> <chr>        <chr>            <chr>       <int>
        1 Selectivity         1 Logistic     inflection_point parameter       1
        2 Selectivity         2 Logistic     inflection_point parameter       2
        3 Selectivity         1 Logistic     slope            parameter       1
        4 Selectivity         2 Logistic     slope            parameter       2
        5 Recruitment         1 BevertonHolt log_rzero        parameter       1
        6 Recruitment         1 BevertonHolt logit_steep      parameter       1
        7 Recruitment         1 BevertonHolt log_devs         parameter       1
        8 Recruitment         1 BevertonHolt log_devs         parameter       2
        9 Recruitment         1 BevertonHolt log_devs         parameter       3
       10 Recruitment         1 BevertonHolt log_devs         parameter       4
       11 Recruitment         1 BevertonHolt log_devs         parameter       5
       12 Recruitment         1 BevertonHolt log_devs         parameter       6
       13 Recruitment         1 BevertonHolt log_devs         parameter       7
       14 Recruitment         1 BevertonHolt log_devs         parameter       8
       15 Recruitment         1 BevertonHolt log_devs         parameter       9
       16 Recruitment         1 BevertonHolt log_devs         parameter      10
       17 Recruitment         1 BevertonHolt log_devs         parameter      11
       18 Recruitment         1 BevertonHolt log_devs         parameter      12
       19 Recruitment         1 BevertonHolt log_devs         parameter      13
       20 Recruitment         1 BevertonHolt log_devs         parameter      14
       21 Recruitment         1 BevertonHolt log_devs         parameter      15
       22 Recruitment         1 BevertonHolt log_devs         parameter      16
       23 Recruitment         1 BevertonHolt log_devs         parameter      17
       24 Recruitment         1 BevertonHolt log_devs         parameter      18
       25 Recruitment         1 BevertonHolt log_devs         parameter      19
       26 Recruitment         1 BevertonHolt log_devs         parameter      20
       27 Recruitment         1 BevertonHolt log_devs         parameter      21
       28 Recruitment         1 BevertonHolt log_devs         parameter      22
       29 Recruitment         1 BevertonHolt log_devs         parameter      23
       30 Recruitment         1 BevertonHolt log_devs         parameter      24
       31 Recruitment         1 BevertonHolt log_devs         parameter      25
       32 Recruitment         1 BevertonHolt log_devs         parameter      26
       33 Recruitment         1 BevertonHolt log_devs         parameter      27
       34 Recruitment         1 BevertonHolt log_devs         parameter      28
       35 Recruitment         1 BevertonHolt log_devs         parameter      29
       36 Recruitment         1 BevertonHolt log_sd           parameter       1
       37 Population          1 <NA>         log_init_naa     parameter       1
       38 Population          1 <NA>         log_init_naa     parameter       2
       39 Population          1 <NA>         log_init_naa     parameter       3
       40 Population          1 <NA>         log_init_naa     parameter       4
       41 Population          1 <NA>         log_init_naa     parameter       5
       42 Population          1 <NA>         log_init_naa     parameter       6
       43 Population          1 <NA>         log_init_naa     parameter       7
       44 Population          1 <NA>         log_init_naa     parameter       8
       45 Population          1 <NA>         log_init_naa     parameter       9
       46 Population          1 <NA>         log_init_naa     parameter      10
       47 Population          1 <NA>         log_init_naa     parameter      11
       48 Population          1 <NA>         log_init_naa     parameter      12
       49 Population          1 <NA>         log_M            parameter       1
       50 Population          1 <NA>         log_M            parameter       2
       51 Population          1 <NA>         log_M            parameter       3
       52 Population          1 <NA>         log_M            parameter       4
       53 Population          1 <NA>         log_M            parameter       5
       54 Population          1 <NA>         log_M            parameter       6
       55 Population          1 <NA>         log_M            parameter       7
       56 Population          1 <NA>         log_M            parameter       8
       57 Population          1 <NA>         log_M            parameter       9
       58 Population          1 <NA>         log_M            parameter      10
       59 Population          1 <NA>         log_M            parameter      11
       60 Population          1 <NA>         log_M            parameter      12
       61 Population          1 <NA>         log_M            parameter      13
       62 Population          1 <NA>         log_M            parameter      14
       63 Population          1 <NA>         log_M            parameter      15
       64 Population          1 <NA>         log_M            parameter      16
       65 Population          1 <NA>         log_M            parameter      17
       66 Population          1 <NA>         log_M            parameter      18
       67 Population          1 <NA>         log_M            parameter      19
       68 Population          1 <NA>         log_M            parameter      20
       69 Population          1 <NA>         log_M            parameter      21
       70 Population          1 <NA>         log_M            parameter      22
       71 Population          1 <NA>         log_M            parameter      23
       72 Population          1 <NA>         log_M            parameter      24
       73 Population          1 <NA>         log_M            parameter      25
       74 Population          1 <NA>         log_M            parameter      26
       75 Population          1 <NA>         log_M            parameter      27
       76 Population          1 <NA>         log_M            parameter      28
       77 Population          1 <NA>         log_M            parameter      29
       78 Population          1 <NA>         log_M            parameter      30
       79 Population          1 <NA>         log_M            parameter      31
       80 Population          1 <NA>         log_M            parameter      32
       81 Population          1 <NA>         log_M            parameter      33
       82 Population          1 <NA>         log_M            parameter      34
       83 Population          1 <NA>         log_M            parameter      35
       84 Population          1 <NA>         log_M            parameter      36
       85 Population          1 <NA>         log_M            parameter      37
       86 Population          1 <NA>         log_M            parameter      38
       87 Population          1 <NA>         log_M            parameter      39
       88 Population          1 <NA>         log_M            parameter      40
       89 Population          1 <NA>         log_M            parameter      41
       90 Population          1 <NA>         log_M            parameter      42
       91 Population          1 <NA>         log_M            parameter      43
       92 Population          1 <NA>         log_M            parameter      44
       93 Population          1 <NA>         log_M            parameter      45
       94 Population          1 <NA>         log_M            parameter      46
       95 Population          1 <NA>         log_M            parameter      47
       96 Population          1 <NA>         log_M            parameter      48
       97 Population          1 <NA>         log_M            parameter      49
       98 Population          1 <NA>         log_M            parameter      50
       99 Population          1 <NA>         log_M            parameter      51
      100 Population          1 <NA>         log_M            parameter      52
      101 Population          1 <NA>         log_M            parameter      53
      102 Population          1 <NA>         log_M            parameter      54
      103 Population          1 <NA>         log_M            parameter      55
      104 Population          1 <NA>         log_M            parameter      56
      105 Population          1 <NA>         log_M            parameter      57
      106 Population          1 <NA>         log_M            parameter      58
      107 Population          1 <NA>         log_M            parameter      59
      108 Population          1 <NA>         log_M            parameter      60
      109 Population          1 <NA>         log_M            parameter      61
      110 Population          1 <NA>         log_M            parameter      62
      111 Population          1 <NA>         log_M            parameter      63
      112 Population          1 <NA>         log_M            parameter      64
      113 Population          1 <NA>         log_M            parameter      65
      114 Population          1 <NA>         log_M            parameter      66
      115 Population          1 <NA>         log_M            parameter      67
      116 Population          1 <NA>         log_M            parameter      68
      117 Population          1 <NA>         log_M            parameter      69
      118 Population          1 <NA>         log_M            parameter      70
      119 Population          1 <NA>         log_M            parameter      71
      120 Population          1 <NA>         log_M            parameter      72
      121 Population          1 <NA>         log_M            parameter      73
      122 Population          1 <NA>         log_M            parameter      74
      123 Population          1 <NA>         log_M            parameter      75
      124 Population          1 <NA>         log_M            parameter      76
      125 Population          1 <NA>         log_M            parameter      77
      126 Population          1 <NA>         log_M            parameter      78
      127 Population          1 <NA>         log_M            parameter      79
      128 Population          1 <NA>         log_M            parameter      80
      129 Population          1 <NA>         log_M            parameter      81
      130 Population          1 <NA>         log_M            parameter      82
      131 Population          1 <NA>         log_M            parameter      83
      132 Population          1 <NA>         log_M            parameter      84
      133 Population          1 <NA>         log_M            parameter      85
      134 Population          1 <NA>         log_M            parameter      86
      135 Population          1 <NA>         log_M            parameter      87
      136 Population          1 <NA>         log_M            parameter      88
      137 Population          1 <NA>         log_M            parameter      89
      138 Population          1 <NA>         log_M            parameter      90
      139 Population          1 <NA>         log_M            parameter      91
      140 Population          1 <NA>         log_M            parameter      92
      141 Population          1 <NA>         log_M            parameter      93
      142 Population          1 <NA>         log_M            parameter      94
      143 Population          1 <NA>         log_M            parameter      95
      144 Population          1 <NA>         log_M            parameter      96
      145 Population          1 <NA>         log_M            parameter      97
      146 Population          1 <NA>         log_M            parameter      98
      147 Population          1 <NA>         log_M            parameter      99
      148 Population          1 <NA>         log_M            parameter     100
      149 Population          1 <NA>         log_M            parameter     101
      150 Population          1 <NA>         log_M            parameter     102
      151 Population          1 <NA>         log_M            parameter     103
      152 Population          1 <NA>         log_M            parameter     104
      153 Population          1 <NA>         log_M            parameter     105
      154 Population          1 <NA>         log_M            parameter     106
      155 Population          1 <NA>         log_M            parameter     107
      156 Population          1 <NA>         log_M            parameter     108
      157 Population          1 <NA>         log_M            parameter     109
      158 Population          1 <NA>         log_M            parameter     110
      159 Population          1 <NA>         log_M            parameter     111
      160 Population          1 <NA>         log_M            parameter     112
      161 Population          1 <NA>         log_M            parameter     113
      162 Population          1 <NA>         log_M            parameter     114
      163 Population          1 <NA>         log_M            parameter     115
      164 Population          1 <NA>         log_M            parameter     116
      165 Population          1 <NA>         log_M            parameter     117
      166 Population          1 <NA>         log_M            parameter     118
      167 Population          1 <NA>         log_M            parameter     119
      168 Population          1 <NA>         log_M            parameter     120
      169 Population          1 <NA>         log_M            parameter     121
      170 Population          1 <NA>         log_M            parameter     122
      171 Population          1 <NA>         log_M            parameter     123
      172 Population          1 <NA>         log_M            parameter     124
      173 Population          1 <NA>         log_M            parameter     125
      174 Population          1 <NA>         log_M            parameter     126
      175 Population          1 <NA>         log_M            parameter     127
      176 Population          1 <NA>         log_M            parameter     128
      177 Population          1 <NA>         log_M            parameter     129
      178 Population          1 <NA>         log_M            parameter     130
      179 Population          1 <NA>         log_M            parameter     131
      180 Population          1 <NA>         log_M            parameter     132
      181 Population          1 <NA>         log_M            parameter     133
      182 Population          1 <NA>         log_M            parameter     134
      183 Population          1 <NA>         log_M            parameter     135
      184 Population          1 <NA>         log_M            parameter     136
      185 Population          1 <NA>         log_M            parameter     137
      186 Population          1 <NA>         log_M            parameter     138
      187 Population          1 <NA>         log_M            parameter     139
      188 Population          1 <NA>         log_M            parameter     140
      189 Population          1 <NA>         log_M            parameter     141
      190 Population          1 <NA>         log_M            parameter     142
      191 Population          1 <NA>         log_M            parameter     143
      192 Population          1 <NA>         log_M            parameter     144
      193 Population          1 <NA>         log_M            parameter     145
      194 Population          1 <NA>         log_M            parameter     146
      195 Population          1 <NA>         log_M            parameter     147
      196 Population          1 <NA>         log_M            parameter     148
      197 Population          1 <NA>         log_M            parameter     149
      198 Population          1 <NA>         log_M            parameter     150
      199 Population          1 <NA>         log_M            parameter     151
      200 Population          1 <NA>         log_M            parameter     152
      201 Population          1 <NA>         log_M            parameter     153
      202 Population          1 <NA>         log_M            parameter     154
      203 Population          1 <NA>         log_M            parameter     155
      204 Population          1 <NA>         log_M            parameter     156
      205 Population          1 <NA>         log_M            parameter     157
      206 Population          1 <NA>         log_M            parameter     158
      207 Population          1 <NA>         log_M            parameter     159
      208 Population          1 <NA>         log_M            parameter     160
      209 Population          1 <NA>         log_M            parameter     161
      210 Population          1 <NA>         log_M            parameter     162
      211 Population          1 <NA>         log_M            parameter     163
      212 Population          1 <NA>         log_M            parameter     164
      213 Population          1 <NA>         log_M            parameter     165
      214 Population          1 <NA>         log_M            parameter     166
      215 Population          1 <NA>         log_M            parameter     167
      216 Population          1 <NA>         log_M            parameter     168
      217 Population          1 <NA>         log_M            parameter     169
      218 Population          1 <NA>         log_M            parameter     170
      219 Population          1 <NA>         log_M            parameter     171
      220 Population          1 <NA>         log_M            parameter     172
      221 Population          1 <NA>         log_M            parameter     173
      222 Population          1 <NA>         log_M            parameter     174
      223 Population          1 <NA>         log_M            parameter     175
      224 Population          1 <NA>         log_M            parameter     176
      225 Population          1 <NA>         log_M            parameter     177
      226 Population          1 <NA>         log_M            parameter     178
      227 Population          1 <NA>         log_M            parameter     179
      228 Population          1 <NA>         log_M            parameter     180
      229 Population          1 <NA>         log_M            parameter     181
      230 Population          1 <NA>         log_M            parameter     182
      231 Population          1 <NA>         log_M            parameter     183
      232 Population          1 <NA>         log_M            parameter     184
      233 Population          1 <NA>         log_M            parameter     185
      234 Population          1 <NA>         log_M            parameter     186
      235 Population          1 <NA>         log_M            parameter     187
      236 Population          1 <NA>         log_M            parameter     188
      237 Population          1 <NA>         log_M            parameter     189
      238 Population          1 <NA>         log_M            parameter     190
      239 Population          1 <NA>         log_M            parameter     191
      240 Population          1 <NA>         log_M            parameter     192
      241 Population          1 <NA>         log_M            parameter     193
      242 Population          1 <NA>         log_M            parameter     194
      243 Population          1 <NA>         log_M            parameter     195
      244 Population          1 <NA>         log_M            parameter     196
      245 Population          1 <NA>         log_M            parameter     197
      246 Population          1 <NA>         log_M            parameter     198
      247 Population          1 <NA>         log_M            parameter     199
      248 Population          1 <NA>         log_M            parameter     200
      249 Population          1 <NA>         log_M            parameter     201
      250 Population          1 <NA>         log_M            parameter     202
      251 Population          1 <NA>         log_M            parameter     203
      252 Population          1 <NA>         log_M            parameter     204
      253 Population          1 <NA>         log_M            parameter     205
      254 Population          1 <NA>         log_M            parameter     206
      255 Population          1 <NA>         log_M            parameter     207
      256 Population          1 <NA>         log_M            parameter     208
      257 Population          1 <NA>         log_M            parameter     209
      258 Population          1 <NA>         log_M            parameter     210
      259 Population          1 <NA>         log_M            parameter     211
      260 Population          1 <NA>         log_M            parameter     212
      261 Population          1 <NA>         log_M            parameter     213
      262 Population          1 <NA>         log_M            parameter     214
      263 Population          1 <NA>         log_M            parameter     215
      264 Population          1 <NA>         log_M            parameter     216
      265 Population          1 <NA>         log_M            parameter     217
      266 Population          1 <NA>         log_M            parameter     218
      267 Population          1 <NA>         log_M            parameter     219
      268 Population          1 <NA>         log_M            parameter     220
      269 Population          1 <NA>         log_M            parameter     221
      270 Population          1 <NA>         log_M            parameter     222
      271 Population          1 <NA>         log_M            parameter     223
      272 Population          1 <NA>         log_M            parameter     224
      273 Population          1 <NA>         log_M            parameter     225
      274 Population          1 <NA>         log_M            parameter     226
      275 Population          1 <NA>         log_M            parameter     227
      276 Population          1 <NA>         log_M            parameter     228
      277 Population          1 <NA>         log_M            parameter     229
      278 Population          1 <NA>         log_M            parameter     230
      279 Population          1 <NA>         log_M            parameter     231
      280 Population          1 <NA>         log_M            parameter     232
      281 Population          1 <NA>         log_M            parameter     233
      282 Population          1 <NA>         log_M            parameter     234
      283 Population          1 <NA>         log_M            parameter     235
      284 Population          1 <NA>         log_M            parameter     236
      285 Population          1 <NA>         log_M            parameter     237
      286 Population          1 <NA>         log_M            parameter     238
      287 Population          1 <NA>         log_M            parameter     239
      288 Population          1 <NA>         log_M            parameter     240
      289 Population          1 <NA>         log_M            parameter     241
      290 Population          1 <NA>         log_M            parameter     242
      291 Population          1 <NA>         log_M            parameter     243
      292 Population          1 <NA>         log_M            parameter     244
      293 Population          1 <NA>         log_M            parameter     245
      294 Population          1 <NA>         log_M            parameter     246
      295 Population          1 <NA>         log_M            parameter     247
      296 Population          1 <NA>         log_M            parameter     248
      297 Population          1 <NA>         log_M            parameter     249
      298 Population          1 <NA>         log_M            parameter     250
      299 Population          1 <NA>         log_M            parameter     251
      300 Population          1 <NA>         log_M            parameter     252
      301 Population          1 <NA>         log_M            parameter     253
      302 Population          1 <NA>         log_M            parameter     254
      303 Population          1 <NA>         log_M            parameter     255
      304 Population          1 <NA>         log_M            parameter     256
      305 Population          1 <NA>         log_M            parameter     257
      306 Population          1 <NA>         log_M            parameter     258
      307 Population          1 <NA>         log_M            parameter     259
      308 Population          1 <NA>         log_M            parameter     260
      309 Population          1 <NA>         log_M            parameter     261
      310 Population          1 <NA>         log_M            parameter     262
      311 Population          1 <NA>         log_M            parameter     263
      312 Population          1 <NA>         log_M            parameter     264
      313 Population          1 <NA>         log_M            parameter     265
      314 Population          1 <NA>         log_M            parameter     266
      315 Population          1 <NA>         log_M            parameter     267
      316 Population          1 <NA>         log_M            parameter     268
      317 Population          1 <NA>         log_M            parameter     269
      318 Population          1 <NA>         log_M            parameter     270
      319 Population          1 <NA>         log_M            parameter     271
      320 Population          1 <NA>         log_M            parameter     272
          parameter_id fleet   year_i   age length   input observed estimation_type
                 <int> <chr>    <int> <dbl>  <dbl>   <dbl>    <dbl> <chr>
        1            1 fleet1      NA    NA     NA  2            NA fixed_effects
        2            2 survey1     NA    NA     NA  1.5          NA fixed_effects
        3            3 fleet1      NA    NA     NA  1            NA fixed_effects
        4            4 survey1     NA    NA     NA  2            NA fixed_effects
        5           13 <NA>        NA    NA     NA 13.8          NA fixed_effects
        6           14 <NA>        NA    NA     NA  0.788        NA constant
        7           15 <NA>         2    NA     NA  0.438        NA random_effects
        8           16 <NA>         3    NA     NA -0.133        NA random_effects
        9           17 <NA>         4    NA     NA -0.433        NA random_effects
       10           18 <NA>         5    NA     NA  0.649        NA random_effects
       11           19 <NA>         6    NA     NA  0.506        NA random_effects
       12           20 <NA>         7    NA     NA -0.0696       NA random_effects
       13           21 <NA>         8    NA     NA  0.302        NA random_effects
       14           22 <NA>         9    NA     NA -0.0826       NA random_effects
       15           23 <NA>        10    NA     NA  0.207        NA random_effects
       16           24 <NA>        11    NA     NA  0.153        NA random_effects
       17           25 <NA>        12    NA     NA -0.217        NA random_effects
       18           26 <NA>        13    NA     NA -0.133        NA random_effects
       19           27 <NA>        14    NA     NA  0.112        NA random_effects
       20           28 <NA>        15    NA     NA -0.107        NA random_effects
       21           29 <NA>        16    NA     NA  0.269        NA random_effects
       22           30 <NA>        17    NA     NA  0.241        NA random_effects
       23           31 <NA>        18    NA     NA -0.545        NA random_effects
       24           32 <NA>        19    NA     NA -0.237        NA random_effects
       25           33 <NA>        20    NA     NA -0.585        NA random_effects
       26           34 <NA>        21    NA     NA  0.301        NA random_effects
       27           35 <NA>        22    NA     NA  0.219        NA random_effects
       28           36 <NA>        23    NA     NA -0.223        NA random_effects
       29           37 <NA>        24    NA     NA -0.514        NA random_effects
       30           38 <NA>        25    NA     NA  0.157        NA random_effects
       31           39 <NA>        26    NA     NA -0.540        NA random_effects
       32           40 <NA>        27    NA     NA -0.196        NA random_effects
       33           41 <NA>        28    NA     NA  0.201        NA random_effects
       34           42 <NA>        29    NA     NA  0.372        NA random_effects
       35           43 <NA>        30    NA     NA -0.0716       NA random_effects
       36           73 <NA>        NA    NA     NA -0.916        NA fixed_effects
       37           74 <NA>        NA     1     NA 13.8          NA fixed_effects
       38           75 <NA>        NA     2     NA 13.6          NA fixed_effects
       39           76 <NA>        NA     3     NA 13.4          NA fixed_effects
       40           77 <NA>        NA     4     NA 13.2          NA fixed_effects
       41           78 <NA>        NA     5     NA 13.0          NA fixed_effects
       42           79 <NA>        NA     6     NA 12.8          NA fixed_effects
       43           80 <NA>        NA     7     NA 12.6          NA fixed_effects
       44           81 <NA>        NA     8     NA 12.4          NA fixed_effects
       45           82 <NA>        NA     9     NA 12.1          NA fixed_effects
       46           83 <NA>        NA    10     NA 11.9          NA fixed_effects
       47           84 <NA>        NA    11     NA 11.7          NA fixed_effects
       48           85 <NA>        NA    12     NA 13.2          NA fixed_effects
       49           86 <NA>         1     1     NA -1.61         NA constant
       50          116 <NA>         1     2     NA -1.61         NA constant
       51          146 <NA>         1     3     NA -1.61         NA constant
       52          176 <NA>         1     4     NA -1.61         NA constant
       53          206 <NA>         1     5     NA -1.61         NA constant
       54          236 <NA>         1     6     NA -1.61         NA constant
       55          266 <NA>         1     7     NA -1.61         NA constant
       56          296 <NA>         1     8     NA -1.61         NA constant
       57          326 <NA>         1     9     NA -1.61         NA constant
       58          356 <NA>         1    10     NA -1.61         NA constant
       59          386 <NA>         1    11     NA -1.61         NA constant
       60          416 <NA>         1    12     NA -1.61         NA constant
       61           87 <NA>         2     1     NA -1.61         NA constant
       62          117 <NA>         2     2     NA -1.61         NA constant
       63          147 <NA>         2     3     NA -1.61         NA constant
       64          177 <NA>         2     4     NA -1.61         NA constant
       65          207 <NA>         2     5     NA -1.61         NA constant
       66          237 <NA>         2     6     NA -1.61         NA constant
       67          267 <NA>         2     7     NA -1.61         NA constant
       68          297 <NA>         2     8     NA -1.61         NA constant
       69          327 <NA>         2     9     NA -1.61         NA constant
       70          357 <NA>         2    10     NA -1.61         NA constant
       71          387 <NA>         2    11     NA -1.61         NA constant
       72          417 <NA>         2    12     NA -1.61         NA constant
       73           88 <NA>         3     1     NA -1.61         NA constant
       74          118 <NA>         3     2     NA -1.61         NA constant
       75          148 <NA>         3     3     NA -1.61         NA constant
       76          178 <NA>         3     4     NA -1.61         NA constant
       77          208 <NA>         3     5     NA -1.61         NA constant
       78          238 <NA>         3     6     NA -1.61         NA constant
       79          268 <NA>         3     7     NA -1.61         NA constant
       80          298 <NA>         3     8     NA -1.61         NA constant
       81          328 <NA>         3     9     NA -1.61         NA constant
       82          358 <NA>         3    10     NA -1.61         NA constant
       83          388 <NA>         3    11     NA -1.61         NA constant
       84          418 <NA>         3    12     NA -1.61         NA constant
       85           89 <NA>         4     1     NA -1.61         NA constant
       86          119 <NA>         4     2     NA -1.61         NA constant
       87          149 <NA>         4     3     NA -1.61         NA constant
       88          179 <NA>         4     4     NA -1.61         NA constant
       89          209 <NA>         4     5     NA -1.61         NA constant
       90          239 <NA>         4     6     NA -1.61         NA constant
       91          269 <NA>         4     7     NA -1.61         NA constant
       92          299 <NA>         4     8     NA -1.61         NA constant
       93          329 <NA>         4     9     NA -1.61         NA constant
       94          359 <NA>         4    10     NA -1.61         NA constant
       95          389 <NA>         4    11     NA -1.61         NA constant
       96          419 <NA>         4    12     NA -1.61         NA constant
       97           90 <NA>         5     1     NA -1.61         NA constant
       98          120 <NA>         5     2     NA -1.61         NA constant
       99          150 <NA>         5     3     NA -1.61         NA constant
      100          180 <NA>         5     4     NA -1.61         NA constant
      101          210 <NA>         5     5     NA -1.61         NA constant
      102          240 <NA>         5     6     NA -1.61         NA constant
      103          270 <NA>         5     7     NA -1.61         NA constant
      104          300 <NA>         5     8     NA -1.61         NA constant
      105          330 <NA>         5     9     NA -1.61         NA constant
      106          360 <NA>         5    10     NA -1.61         NA constant
      107          390 <NA>         5    11     NA -1.61         NA constant
      108          420 <NA>         5    12     NA -1.61         NA constant
      109           91 <NA>         6     1     NA -1.61         NA constant
      110          121 <NA>         6     2     NA -1.61         NA constant
      111          151 <NA>         6     3     NA -1.61         NA constant
      112          181 <NA>         6     4     NA -1.61         NA constant
      113          211 <NA>         6     5     NA -1.61         NA constant
      114          241 <NA>         6     6     NA -1.61         NA constant
      115          271 <NA>         6     7     NA -1.61         NA constant
      116          301 <NA>         6     8     NA -1.61         NA constant
      117          331 <NA>         6     9     NA -1.61         NA constant
      118          361 <NA>         6    10     NA -1.61         NA constant
      119          391 <NA>         6    11     NA -1.61         NA constant
      120          421 <NA>         6    12     NA -1.61         NA constant
      121           92 <NA>         7     1     NA -1.61         NA constant
      122          122 <NA>         7     2     NA -1.61         NA constant
      123          152 <NA>         7     3     NA -1.61         NA constant
      124          182 <NA>         7     4     NA -1.61         NA constant
      125          212 <NA>         7     5     NA -1.61         NA constant
      126          242 <NA>         7     6     NA -1.61         NA constant
      127          272 <NA>         7     7     NA -1.61         NA constant
      128          302 <NA>         7     8     NA -1.61         NA constant
      129          332 <NA>         7     9     NA -1.61         NA constant
      130          362 <NA>         7    10     NA -1.61         NA constant
      131          392 <NA>         7    11     NA -1.61         NA constant
      132          422 <NA>         7    12     NA -1.61         NA constant
      133           93 <NA>         8     1     NA -1.61         NA constant
      134          123 <NA>         8     2     NA -1.61         NA constant
      135          153 <NA>         8     3     NA -1.61         NA constant
      136          183 <NA>         8     4     NA -1.61         NA constant
      137          213 <NA>         8     5     NA -1.61         NA constant
      138          243 <NA>         8     6     NA -1.61         NA constant
      139          273 <NA>         8     7     NA -1.61         NA constant
      140          303 <NA>         8     8     NA -1.61         NA constant
      141          333 <NA>         8     9     NA -1.61         NA constant
      142          363 <NA>         8    10     NA -1.61         NA constant
      143          393 <NA>         8    11     NA -1.61         NA constant
      144          423 <NA>         8    12     NA -1.61         NA constant
      145           94 <NA>         9     1     NA -1.61         NA constant
      146          124 <NA>         9     2     NA -1.61         NA constant
      147          154 <NA>         9     3     NA -1.61         NA constant
      148          184 <NA>         9     4     NA -1.61         NA constant
      149          214 <NA>         9     5     NA -1.61         NA constant
      150          244 <NA>         9     6     NA -1.61         NA constant
      151          274 <NA>         9     7     NA -1.61         NA constant
      152          304 <NA>         9     8     NA -1.61         NA constant
      153          334 <NA>         9     9     NA -1.61         NA constant
      154          364 <NA>         9    10     NA -1.61         NA constant
      155          394 <NA>         9    11     NA -1.61         NA constant
      156          424 <NA>         9    12     NA -1.61         NA constant
      157           95 <NA>        10     1     NA -1.61         NA constant
      158          125 <NA>        10     2     NA -1.61         NA constant
      159          155 <NA>        10     3     NA -1.61         NA constant
      160          185 <NA>        10     4     NA -1.61         NA constant
      161          215 <NA>        10     5     NA -1.61         NA constant
      162          245 <NA>        10     6     NA -1.61         NA constant
      163          275 <NA>        10     7     NA -1.61         NA constant
      164          305 <NA>        10     8     NA -1.61         NA constant
      165          335 <NA>        10     9     NA -1.61         NA constant
      166          365 <NA>        10    10     NA -1.61         NA constant
      167          395 <NA>        10    11     NA -1.61         NA constant
      168          425 <NA>        10    12     NA -1.61         NA constant
      169           96 <NA>        11     1     NA -1.61         NA constant
      170          126 <NA>        11     2     NA -1.61         NA constant
      171          156 <NA>        11     3     NA -1.61         NA constant
      172          186 <NA>        11     4     NA -1.61         NA constant
      173          216 <NA>        11     5     NA -1.61         NA constant
      174          246 <NA>        11     6     NA -1.61         NA constant
      175          276 <NA>        11     7     NA -1.61         NA constant
      176          306 <NA>        11     8     NA -1.61         NA constant
      177          336 <NA>        11     9     NA -1.61         NA constant
      178          366 <NA>        11    10     NA -1.61         NA constant
      179          396 <NA>        11    11     NA -1.61         NA constant
      180          426 <NA>        11    12     NA -1.61         NA constant
      181           97 <NA>        12     1     NA -1.61         NA constant
      182          127 <NA>        12     2     NA -1.61         NA constant
      183          157 <NA>        12     3     NA -1.61         NA constant
      184          187 <NA>        12     4     NA -1.61         NA constant
      185          217 <NA>        12     5     NA -1.61         NA constant
      186          247 <NA>        12     6     NA -1.61         NA constant
      187          277 <NA>        12     7     NA -1.61         NA constant
      188          307 <NA>        12     8     NA -1.61         NA constant
      189          337 <NA>        12     9     NA -1.61         NA constant
      190          367 <NA>        12    10     NA -1.61         NA constant
      191          397 <NA>        12    11     NA -1.61         NA constant
      192          427 <NA>        12    12     NA -1.61         NA constant
      193           98 <NA>        13     1     NA -1.61         NA constant
      194          128 <NA>        13     2     NA -1.61         NA constant
      195          158 <NA>        13     3     NA -1.61         NA constant
      196          188 <NA>        13     4     NA -1.61         NA constant
      197          218 <NA>        13     5     NA -1.61         NA constant
      198          248 <NA>        13     6     NA -1.61         NA constant
      199          278 <NA>        13     7     NA -1.61         NA constant
      200          308 <NA>        13     8     NA -1.61         NA constant
      201          338 <NA>        13     9     NA -1.61         NA constant
      202          368 <NA>        13    10     NA -1.61         NA constant
      203          398 <NA>        13    11     NA -1.61         NA constant
      204          428 <NA>        13    12     NA -1.61         NA constant
      205           99 <NA>        14     1     NA -1.61         NA constant
      206          129 <NA>        14     2     NA -1.61         NA constant
      207          159 <NA>        14     3     NA -1.61         NA constant
      208          189 <NA>        14     4     NA -1.61         NA constant
      209          219 <NA>        14     5     NA -1.61         NA constant
      210          249 <NA>        14     6     NA -1.61         NA constant
      211          279 <NA>        14     7     NA -1.61         NA constant
      212          309 <NA>        14     8     NA -1.61         NA constant
      213          339 <NA>        14     9     NA -1.61         NA constant
      214          369 <NA>        14    10     NA -1.61         NA constant
      215          399 <NA>        14    11     NA -1.61         NA constant
      216          429 <NA>        14    12     NA -1.61         NA constant
      217          100 <NA>        15     1     NA -1.61         NA constant
      218          130 <NA>        15     2     NA -1.61         NA constant
      219          160 <NA>        15     3     NA -1.61         NA constant
      220          190 <NA>        15     4     NA -1.61         NA constant
      221          220 <NA>        15     5     NA -1.61         NA constant
      222          250 <NA>        15     6     NA -1.61         NA constant
      223          280 <NA>        15     7     NA -1.61         NA constant
      224          310 <NA>        15     8     NA -1.61         NA constant
      225          340 <NA>        15     9     NA -1.61         NA constant
      226          370 <NA>        15    10     NA -1.61         NA constant
      227          400 <NA>        15    11     NA -1.61         NA constant
      228          430 <NA>        15    12     NA -1.61         NA constant
      229          101 <NA>        16     1     NA -1.61         NA constant
      230          131 <NA>        16     2     NA -1.61         NA constant
      231          161 <NA>        16     3     NA -1.61         NA constant
      232          191 <NA>        16     4     NA -1.61         NA constant
      233          221 <NA>        16     5     NA -1.61         NA constant
      234          251 <NA>        16     6     NA -1.61         NA constant
      235          281 <NA>        16     7     NA -1.61         NA constant
      236          311 <NA>        16     8     NA -1.61         NA constant
      237          341 <NA>        16     9     NA -1.61         NA constant
      238          371 <NA>        16    10     NA -1.61         NA constant
      239          401 <NA>        16    11     NA -1.61         NA constant
      240          431 <NA>        16    12     NA -1.61         NA constant
      241          102 <NA>        17     1     NA -1.61         NA constant
      242          132 <NA>        17     2     NA -1.61         NA constant
      243          162 <NA>        17     3     NA -1.61         NA constant
      244          192 <NA>        17     4     NA -1.61         NA constant
      245          222 <NA>        17     5     NA -1.61         NA constant
      246          252 <NA>        17     6     NA -1.61         NA constant
      247          282 <NA>        17     7     NA -1.61         NA constant
      248          312 <NA>        17     8     NA -1.61         NA constant
      249          342 <NA>        17     9     NA -1.61         NA constant
      250          372 <NA>        17    10     NA -1.61         NA constant
      251          402 <NA>        17    11     NA -1.61         NA constant
      252          432 <NA>        17    12     NA -1.61         NA constant
      253          103 <NA>        18     1     NA -1.61         NA constant
      254          133 <NA>        18     2     NA -1.61         NA constant
      255          163 <NA>        18     3     NA -1.61         NA constant
      256          193 <NA>        18     4     NA -1.61         NA constant
      257          223 <NA>        18     5     NA -1.61         NA constant
      258          253 <NA>        18     6     NA -1.61         NA constant
      259          283 <NA>        18     7     NA -1.61         NA constant
      260          313 <NA>        18     8     NA -1.61         NA constant
      261          343 <NA>        18     9     NA -1.61         NA constant
      262          373 <NA>        18    10     NA -1.61         NA constant
      263          403 <NA>        18    11     NA -1.61         NA constant
      264          433 <NA>        18    12     NA -1.61         NA constant
      265          104 <NA>        19     1     NA -1.61         NA constant
      266          134 <NA>        19     2     NA -1.61         NA constant
      267          164 <NA>        19     3     NA -1.61         NA constant
      268          194 <NA>        19     4     NA -1.61         NA constant
      269          224 <NA>        19     5     NA -1.61         NA constant
      270          254 <NA>        19     6     NA -1.61         NA constant
      271          284 <NA>        19     7     NA -1.61         NA constant
      272          314 <NA>        19     8     NA -1.61         NA constant
      273          344 <NA>        19     9     NA -1.61         NA constant
      274          374 <NA>        19    10     NA -1.61         NA constant
      275          404 <NA>        19    11     NA -1.61         NA constant
      276          434 <NA>        19    12     NA -1.61         NA constant
      277          105 <NA>        20     1     NA -1.61         NA constant
      278          135 <NA>        20     2     NA -1.61         NA constant
      279          165 <NA>        20     3     NA -1.61         NA constant
      280          195 <NA>        20     4     NA -1.61         NA constant
      281          225 <NA>        20     5     NA -1.61         NA constant
      282          255 <NA>        20     6     NA -1.61         NA constant
      283          285 <NA>        20     7     NA -1.61         NA constant
      284          315 <NA>        20     8     NA -1.61         NA constant
      285          345 <NA>        20     9     NA -1.61         NA constant
      286          375 <NA>        20    10     NA -1.61         NA constant
      287          405 <NA>        20    11     NA -1.61         NA constant
      288          435 <NA>        20    12     NA -1.61         NA constant
      289          106 <NA>        21     1     NA -1.61         NA constant
      290          136 <NA>        21     2     NA -1.61         NA constant
      291          166 <NA>        21     3     NA -1.61         NA constant
      292          196 <NA>        21     4     NA -1.61         NA constant
      293          226 <NA>        21     5     NA -1.61         NA constant
      294          256 <NA>        21     6     NA -1.61         NA constant
      295          286 <NA>        21     7     NA -1.61         NA constant
      296          316 <NA>        21     8     NA -1.61         NA constant
      297          346 <NA>        21     9     NA -1.61         NA constant
      298          376 <NA>        21    10     NA -1.61         NA constant
      299          406 <NA>        21    11     NA -1.61         NA constant
      300          436 <NA>        21    12     NA -1.61         NA constant
      301          107 <NA>        22     1     NA -1.61         NA constant
      302          137 <NA>        22     2     NA -1.61         NA constant
      303          167 <NA>        22     3     NA -1.61         NA constant
      304          197 <NA>        22     4     NA -1.61         NA constant
      305          227 <NA>        22     5     NA -1.61         NA constant
      306          257 <NA>        22     6     NA -1.61         NA constant
      307          287 <NA>        22     7     NA -1.61         NA constant
      308          317 <NA>        22     8     NA -1.61         NA constant
      309          347 <NA>        22     9     NA -1.61         NA constant
      310          377 <NA>        22    10     NA -1.61         NA constant
      311          407 <NA>        22    11     NA -1.61         NA constant
      312          437 <NA>        22    12     NA -1.61         NA constant
      313          108 <NA>        23     1     NA -1.61         NA constant
      314          138 <NA>        23     2     NA -1.61         NA constant
      315          168 <NA>        23     3     NA -1.61         NA constant
      316          198 <NA>        23     4     NA -1.61         NA constant
      317          228 <NA>        23     5     NA -1.61         NA constant
      318          258 <NA>        23     6     NA -1.61         NA constant
      319          288 <NA>        23     7     NA -1.61         NA constant
      320          318 <NA>        23     8     NA -1.61         NA constant
          distribution input_type      lpdf log_sd
          <chr>        <chr>          <dbl>  <dbl>
        1 <NA>         fixed_effects     NA     NA
        2 <NA>         fixed_effects     NA     NA
        3 <NA>         fixed_effects     NA     NA
        4 <NA>         fixed_effects     NA     NA
        5 <NA>         fixed_effects     NA     NA
        6 <NA>         constant          NA     NA
        7 normal       random_effects    NA     NA
        8 normal       random_effects    NA     NA
        9 normal       random_effects    NA     NA
       10 normal       random_effects    NA     NA
       11 normal       random_effects    NA     NA
       12 normal       random_effects    NA     NA
       13 normal       random_effects    NA     NA
       14 normal       random_effects    NA     NA
       15 normal       random_effects    NA     NA
       16 normal       random_effects    NA     NA
       17 normal       random_effects    NA     NA
       18 normal       random_effects    NA     NA
       19 normal       random_effects    NA     NA
       20 normal       random_effects    NA     NA
       21 normal       random_effects    NA     NA
       22 normal       random_effects    NA     NA
       23 normal       random_effects    NA     NA
       24 normal       random_effects    NA     NA
       25 normal       random_effects    NA     NA
       26 normal       random_effects    NA     NA
       27 normal       random_effects    NA     NA
       28 normal       random_effects    NA     NA
       29 normal       random_effects    NA     NA
       30 normal       random_effects    NA     NA
       31 normal       random_effects    NA     NA
       32 normal       random_effects    NA     NA
       33 normal       random_effects    NA     NA
       34 normal       random_effects    NA     NA
       35 normal       random_effects    NA     NA
       36 normal       fixed_effects     NA     NA
       37 <NA>         fixed_effects     NA     NA
       38 <NA>         fixed_effects     NA     NA
       39 <NA>         fixed_effects     NA     NA
       40 <NA>         fixed_effects     NA     NA
       41 <NA>         fixed_effects     NA     NA
       42 <NA>         fixed_effects     NA     NA
       43 <NA>         fixed_effects     NA     NA
       44 <NA>         fixed_effects     NA     NA
       45 <NA>         fixed_effects     NA     NA
       46 <NA>         fixed_effects     NA     NA
       47 <NA>         fixed_effects     NA     NA
       48 <NA>         fixed_effects     NA     NA
       49 <NA>         constant          NA     NA
       50 <NA>         constant          NA     NA
       51 <NA>         constant          NA     NA
       52 <NA>         constant          NA     NA
       53 <NA>         constant          NA     NA
       54 <NA>         constant          NA     NA
       55 <NA>         constant          NA     NA
       56 <NA>         constant          NA     NA
       57 <NA>         constant          NA     NA
       58 <NA>         constant          NA     NA
       59 <NA>         constant          NA     NA
       60 <NA>         constant          NA     NA
       61 <NA>         constant          NA     NA
       62 <NA>         constant          NA     NA
       63 <NA>         constant          NA     NA
       64 <NA>         constant          NA     NA
       65 <NA>         constant          NA     NA
       66 <NA>         constant          NA     NA
       67 <NA>         constant          NA     NA
       68 <NA>         constant          NA     NA
       69 <NA>         constant          NA     NA
       70 <NA>         constant          NA     NA
       71 <NA>         constant          NA     NA
       72 <NA>         constant          NA     NA
       73 <NA>         constant          NA     NA
       74 <NA>         constant          NA     NA
       75 <NA>         constant          NA     NA
       76 <NA>         constant          NA     NA
       77 <NA>         constant          NA     NA
       78 <NA>         constant          NA     NA
       79 <NA>         constant          NA     NA
       80 <NA>         constant          NA     NA
       81 <NA>         constant          NA     NA
       82 <NA>         constant          NA     NA
       83 <NA>         constant          NA     NA
       84 <NA>         constant          NA     NA
       85 <NA>         constant          NA     NA
       86 <NA>         constant          NA     NA
       87 <NA>         constant          NA     NA
       88 <NA>         constant          NA     NA
       89 <NA>         constant          NA     NA
       90 <NA>         constant          NA     NA
       91 <NA>         constant          NA     NA
       92 <NA>         constant          NA     NA
       93 <NA>         constant          NA     NA
       94 <NA>         constant          NA     NA
       95 <NA>         constant          NA     NA
       96 <NA>         constant          NA     NA
       97 <NA>         constant          NA     NA
       98 <NA>         constant          NA     NA
       99 <NA>         constant          NA     NA
      100 <NA>         constant          NA     NA
      101 <NA>         constant          NA     NA
      102 <NA>         constant          NA     NA
      103 <NA>         constant          NA     NA
      104 <NA>         constant          NA     NA
      105 <NA>         constant          NA     NA
      106 <NA>         constant          NA     NA
      107 <NA>         constant          NA     NA
      108 <NA>         constant          NA     NA
      109 <NA>         constant          NA     NA
      110 <NA>         constant          NA     NA
      111 <NA>         constant          NA     NA
      112 <NA>         constant          NA     NA
      113 <NA>         constant          NA     NA
      114 <NA>         constant          NA     NA
      115 <NA>         constant          NA     NA
      116 <NA>         constant          NA     NA
      117 <NA>         constant          NA     NA
      118 <NA>         constant          NA     NA
      119 <NA>         constant          NA     NA
      120 <NA>         constant          NA     NA
      121 <NA>         constant          NA     NA
      122 <NA>         constant          NA     NA
      123 <NA>         constant          NA     NA
      124 <NA>         constant          NA     NA
      125 <NA>         constant          NA     NA
      126 <NA>         constant          NA     NA
      127 <NA>         constant          NA     NA
      128 <NA>         constant          NA     NA
      129 <NA>         constant          NA     NA
      130 <NA>         constant          NA     NA
      131 <NA>         constant          NA     NA
      132 <NA>         constant          NA     NA
      133 <NA>         constant          NA     NA
      134 <NA>         constant          NA     NA
      135 <NA>         constant          NA     NA
      136 <NA>         constant          NA     NA
      137 <NA>         constant          NA     NA
      138 <NA>         constant          NA     NA
      139 <NA>         constant          NA     NA
      140 <NA>         constant          NA     NA
      141 <NA>         constant          NA     NA
      142 <NA>         constant          NA     NA
      143 <NA>         constant          NA     NA
      144 <NA>         constant          NA     NA
      145 <NA>         constant          NA     NA
      146 <NA>         constant          NA     NA
      147 <NA>         constant          NA     NA
      148 <NA>         constant          NA     NA
      149 <NA>         constant          NA     NA
      150 <NA>         constant          NA     NA
      151 <NA>         constant          NA     NA
      152 <NA>         constant          NA     NA
      153 <NA>         constant          NA     NA
      154 <NA>         constant          NA     NA
      155 <NA>         constant          NA     NA
      156 <NA>         constant          NA     NA
      157 <NA>         constant          NA     NA
      158 <NA>         constant          NA     NA
      159 <NA>         constant          NA     NA
      160 <NA>         constant          NA     NA
      161 <NA>         constant          NA     NA
      162 <NA>         constant          NA     NA
      163 <NA>         constant          NA     NA
      164 <NA>         constant          NA     NA
      165 <NA>         constant          NA     NA
      166 <NA>         constant          NA     NA
      167 <NA>         constant          NA     NA
      168 <NA>         constant          NA     NA
      169 <NA>         constant          NA     NA
      170 <NA>         constant          NA     NA
      171 <NA>         constant          NA     NA
      172 <NA>         constant          NA     NA
      173 <NA>         constant          NA     NA
      174 <NA>         constant          NA     NA
      175 <NA>         constant          NA     NA
      176 <NA>         constant          NA     NA
      177 <NA>         constant          NA     NA
      178 <NA>         constant          NA     NA
      179 <NA>         constant          NA     NA
      180 <NA>         constant          NA     NA
      181 <NA>         constant          NA     NA
      182 <NA>         constant          NA     NA
      183 <NA>         constant          NA     NA
      184 <NA>         constant          NA     NA
      185 <NA>         constant          NA     NA
      186 <NA>         constant          NA     NA
      187 <NA>         constant          NA     NA
      188 <NA>         constant          NA     NA
      189 <NA>         constant          NA     NA
      190 <NA>         constant          NA     NA
      191 <NA>         constant          NA     NA
      192 <NA>         constant          NA     NA
      193 <NA>         constant          NA     NA
      194 <NA>         constant          NA     NA
      195 <NA>         constant          NA     NA
      196 <NA>         constant          NA     NA
      197 <NA>         constant          NA     NA
      198 <NA>         constant          NA     NA
      199 <NA>         constant          NA     NA
      200 <NA>         constant          NA     NA
      201 <NA>         constant          NA     NA
      202 <NA>         constant          NA     NA
      203 <NA>         constant          NA     NA
      204 <NA>         constant          NA     NA
      205 <NA>         constant          NA     NA
      206 <NA>         constant          NA     NA
      207 <NA>         constant          NA     NA
      208 <NA>         constant          NA     NA
      209 <NA>         constant          NA     NA
      210 <NA>         constant          NA     NA
      211 <NA>         constant          NA     NA
      212 <NA>         constant          NA     NA
      213 <NA>         constant          NA     NA
      214 <NA>         constant          NA     NA
      215 <NA>         constant          NA     NA
      216 <NA>         constant          NA     NA
      217 <NA>         constant          NA     NA
      218 <NA>         constant          NA     NA
      219 <NA>         constant          NA     NA
      220 <NA>         constant          NA     NA
      221 <NA>         constant          NA     NA
      222 <NA>         constant          NA     NA
      223 <NA>         constant          NA     NA
      224 <NA>         constant          NA     NA
      225 <NA>         constant          NA     NA
      226 <NA>         constant          NA     NA
      227 <NA>         constant          NA     NA
      228 <NA>         constant          NA     NA
      229 <NA>         constant          NA     NA
      230 <NA>         constant          NA     NA
      231 <NA>         constant          NA     NA
      232 <NA>         constant          NA     NA
      233 <NA>         constant          NA     NA
      234 <NA>         constant          NA     NA
      235 <NA>         constant          NA     NA
      236 <NA>         constant          NA     NA
      237 <NA>         constant          NA     NA
      238 <NA>         constant          NA     NA
      239 <NA>         constant          NA     NA
      240 <NA>         constant          NA     NA
      241 <NA>         constant          NA     NA
      242 <NA>         constant          NA     NA
      243 <NA>         constant          NA     NA
      244 <NA>         constant          NA     NA
      245 <NA>         constant          NA     NA
      246 <NA>         constant          NA     NA
      247 <NA>         constant          NA     NA
      248 <NA>         constant          NA     NA
      249 <NA>         constant          NA     NA
      250 <NA>         constant          NA     NA
      251 <NA>         constant          NA     NA
      252 <NA>         constant          NA     NA
      253 <NA>         constant          NA     NA
      254 <NA>         constant          NA     NA
      255 <NA>         constant          NA     NA
      256 <NA>         constant          NA     NA
      257 <NA>         constant          NA     NA
      258 <NA>         constant          NA     NA
      259 <NA>         constant          NA     NA
      260 <NA>         constant          NA     NA
      261 <NA>         constant          NA     NA
      262 <NA>         constant          NA     NA
      263 <NA>         constant          NA     NA
      264 <NA>         constant          NA     NA
      265 <NA>         constant          NA     NA
      266 <NA>         constant          NA     NA
      267 <NA>         constant          NA     NA
      268 <NA>         constant          NA     NA
      269 <NA>         constant          NA     NA
      270 <NA>         constant          NA     NA
      271 <NA>         constant          NA     NA
      272 <NA>         constant          NA     NA
      273 <NA>         constant          NA     NA
      274 <NA>         constant          NA     NA
      275 <NA>         constant          NA     NA
      276 <NA>         constant          NA     NA
      277 <NA>         constant          NA     NA
      278 <NA>         constant          NA     NA
      279 <NA>         constant          NA     NA
      280 <NA>         constant          NA     NA
      281 <NA>         constant          NA     NA
      282 <NA>         constant          NA     NA
      283 <NA>         constant          NA     NA
      284 <NA>         constant          NA     NA
      285 <NA>         constant          NA     NA
      286 <NA>         constant          NA     NA
      287 <NA>         constant          NA     NA
      288 <NA>         constant          NA     NA
      289 <NA>         constant          NA     NA
      290 <NA>         constant          NA     NA
      291 <NA>         constant          NA     NA
      292 <NA>         constant          NA     NA
      293 <NA>         constant          NA     NA
      294 <NA>         constant          NA     NA
      295 <NA>         constant          NA     NA
      296 <NA>         constant          NA     NA
      297 <NA>         constant          NA     NA
      298 <NA>         constant          NA     NA
      299 <NA>         constant          NA     NA
      300 <NA>         constant          NA     NA
      301 <NA>         constant          NA     NA
      302 <NA>         constant          NA     NA
      303 <NA>         constant          NA     NA
      304 <NA>         constant          NA     NA
      305 <NA>         constant          NA     NA
      306 <NA>         constant          NA     NA
      307 <NA>         constant          NA     NA
      308 <NA>         constant          NA     NA
      309 <NA>         constant          NA     NA
      310 <NA>         constant          NA     NA
      311 <NA>         constant          NA     NA
      312 <NA>         constant          NA     NA
      313 <NA>         constant          NA     NA
      314 <NA>         constant          NA     NA
      315 <NA>         constant          NA     NA
      316 <NA>         constant          NA     NA
      317 <NA>         constant          NA     NA
      318 <NA>         constant          NA     NA
      319 <NA>         constant          NA     NA
      320 <NA>         constant          NA     NA
      # i 13,654 more rows

# `get_estimates()` works with estimation run

    Code
      estimates_snapshot <- dplyr::select(estimates_big_optimized, -estimated,
        -expected, -uncertainty, -gradient, -likelihood, -log_like_cv)
      estimates_snapshot_lines <- capture.output(print(estimates_snapshot, n = 320,
        width = Inf))
      cat(trimws(estimates_snapshot_lines, which = "right"), sep = "\n")
    Output
      # A tibble: 13,974 x 18
          module_name module_id module_type  label            type      type_id
          <chr>           <int> <chr>        <chr>            <chr>       <int>
        1 Selectivity         1 Logistic     inflection_point parameter       1
        2 Selectivity         2 Logistic     inflection_point parameter       2
        3 Selectivity         1 Logistic     slope            parameter       1
        4 Selectivity         2 Logistic     slope            parameter       2
        5 Recruitment         1 BevertonHolt log_rzero        parameter       1
        6 Recruitment         1 BevertonHolt logit_steep      parameter       1
        7 Recruitment         1 BevertonHolt log_devs         parameter       1
        8 Recruitment         1 BevertonHolt log_devs         parameter       2
        9 Recruitment         1 BevertonHolt log_devs         parameter       3
       10 Recruitment         1 BevertonHolt log_devs         parameter       4
       11 Recruitment         1 BevertonHolt log_devs         parameter       5
       12 Recruitment         1 BevertonHolt log_devs         parameter       6
       13 Recruitment         1 BevertonHolt log_devs         parameter       7
       14 Recruitment         1 BevertonHolt log_devs         parameter       8
       15 Recruitment         1 BevertonHolt log_devs         parameter       9
       16 Recruitment         1 BevertonHolt log_devs         parameter      10
       17 Recruitment         1 BevertonHolt log_devs         parameter      11
       18 Recruitment         1 BevertonHolt log_devs         parameter      12
       19 Recruitment         1 BevertonHolt log_devs         parameter      13
       20 Recruitment         1 BevertonHolt log_devs         parameter      14
       21 Recruitment         1 BevertonHolt log_devs         parameter      15
       22 Recruitment         1 BevertonHolt log_devs         parameter      16
       23 Recruitment         1 BevertonHolt log_devs         parameter      17
       24 Recruitment         1 BevertonHolt log_devs         parameter      18
       25 Recruitment         1 BevertonHolt log_devs         parameter      19
       26 Recruitment         1 BevertonHolt log_devs         parameter      20
       27 Recruitment         1 BevertonHolt log_devs         parameter      21
       28 Recruitment         1 BevertonHolt log_devs         parameter      22
       29 Recruitment         1 BevertonHolt log_devs         parameter      23
       30 Recruitment         1 BevertonHolt log_devs         parameter      24
       31 Recruitment         1 BevertonHolt log_devs         parameter      25
       32 Recruitment         1 BevertonHolt log_devs         parameter      26
       33 Recruitment         1 BevertonHolt log_devs         parameter      27
       34 Recruitment         1 BevertonHolt log_devs         parameter      28
       35 Recruitment         1 BevertonHolt log_devs         parameter      29
       36 Recruitment         1 BevertonHolt log_sd           parameter       1
       37 Population          1 <NA>         log_init_naa     parameter       1
       38 Population          1 <NA>         log_init_naa     parameter       2
       39 Population          1 <NA>         log_init_naa     parameter       3
       40 Population          1 <NA>         log_init_naa     parameter       4
       41 Population          1 <NA>         log_init_naa     parameter       5
       42 Population          1 <NA>         log_init_naa     parameter       6
       43 Population          1 <NA>         log_init_naa     parameter       7
       44 Population          1 <NA>         log_init_naa     parameter       8
       45 Population          1 <NA>         log_init_naa     parameter       9
       46 Population          1 <NA>         log_init_naa     parameter      10
       47 Population          1 <NA>         log_init_naa     parameter      11
       48 Population          1 <NA>         log_init_naa     parameter      12
       49 Population          1 <NA>         log_M            parameter       1
       50 Population          1 <NA>         log_M            parameter       2
       51 Population          1 <NA>         log_M            parameter       3
       52 Population          1 <NA>         log_M            parameter       4
       53 Population          1 <NA>         log_M            parameter       5
       54 Population          1 <NA>         log_M            parameter       6
       55 Population          1 <NA>         log_M            parameter       7
       56 Population          1 <NA>         log_M            parameter       8
       57 Population          1 <NA>         log_M            parameter       9
       58 Population          1 <NA>         log_M            parameter      10
       59 Population          1 <NA>         log_M            parameter      11
       60 Population          1 <NA>         log_M            parameter      12
       61 Population          1 <NA>         log_M            parameter      13
       62 Population          1 <NA>         log_M            parameter      14
       63 Population          1 <NA>         log_M            parameter      15
       64 Population          1 <NA>         log_M            parameter      16
       65 Population          1 <NA>         log_M            parameter      17
       66 Population          1 <NA>         log_M            parameter      18
       67 Population          1 <NA>         log_M            parameter      19
       68 Population          1 <NA>         log_M            parameter      20
       69 Population          1 <NA>         log_M            parameter      21
       70 Population          1 <NA>         log_M            parameter      22
       71 Population          1 <NA>         log_M            parameter      23
       72 Population          1 <NA>         log_M            parameter      24
       73 Population          1 <NA>         log_M            parameter      25
       74 Population          1 <NA>         log_M            parameter      26
       75 Population          1 <NA>         log_M            parameter      27
       76 Population          1 <NA>         log_M            parameter      28
       77 Population          1 <NA>         log_M            parameter      29
       78 Population          1 <NA>         log_M            parameter      30
       79 Population          1 <NA>         log_M            parameter      31
       80 Population          1 <NA>         log_M            parameter      32
       81 Population          1 <NA>         log_M            parameter      33
       82 Population          1 <NA>         log_M            parameter      34
       83 Population          1 <NA>         log_M            parameter      35
       84 Population          1 <NA>         log_M            parameter      36
       85 Population          1 <NA>         log_M            parameter      37
       86 Population          1 <NA>         log_M            parameter      38
       87 Population          1 <NA>         log_M            parameter      39
       88 Population          1 <NA>         log_M            parameter      40
       89 Population          1 <NA>         log_M            parameter      41
       90 Population          1 <NA>         log_M            parameter      42
       91 Population          1 <NA>         log_M            parameter      43
       92 Population          1 <NA>         log_M            parameter      44
       93 Population          1 <NA>         log_M            parameter      45
       94 Population          1 <NA>         log_M            parameter      46
       95 Population          1 <NA>         log_M            parameter      47
       96 Population          1 <NA>         log_M            parameter      48
       97 Population          1 <NA>         log_M            parameter      49
       98 Population          1 <NA>         log_M            parameter      50
       99 Population          1 <NA>         log_M            parameter      51
      100 Population          1 <NA>         log_M            parameter      52
      101 Population          1 <NA>         log_M            parameter      53
      102 Population          1 <NA>         log_M            parameter      54
      103 Population          1 <NA>         log_M            parameter      55
      104 Population          1 <NA>         log_M            parameter      56
      105 Population          1 <NA>         log_M            parameter      57
      106 Population          1 <NA>         log_M            parameter      58
      107 Population          1 <NA>         log_M            parameter      59
      108 Population          1 <NA>         log_M            parameter      60
      109 Population          1 <NA>         log_M            parameter      61
      110 Population          1 <NA>         log_M            parameter      62
      111 Population          1 <NA>         log_M            parameter      63
      112 Population          1 <NA>         log_M            parameter      64
      113 Population          1 <NA>         log_M            parameter      65
      114 Population          1 <NA>         log_M            parameter      66
      115 Population          1 <NA>         log_M            parameter      67
      116 Population          1 <NA>         log_M            parameter      68
      117 Population          1 <NA>         log_M            parameter      69
      118 Population          1 <NA>         log_M            parameter      70
      119 Population          1 <NA>         log_M            parameter      71
      120 Population          1 <NA>         log_M            parameter      72
      121 Population          1 <NA>         log_M            parameter      73
      122 Population          1 <NA>         log_M            parameter      74
      123 Population          1 <NA>         log_M            parameter      75
      124 Population          1 <NA>         log_M            parameter      76
      125 Population          1 <NA>         log_M            parameter      77
      126 Population          1 <NA>         log_M            parameter      78
      127 Population          1 <NA>         log_M            parameter      79
      128 Population          1 <NA>         log_M            parameter      80
      129 Population          1 <NA>         log_M            parameter      81
      130 Population          1 <NA>         log_M            parameter      82
      131 Population          1 <NA>         log_M            parameter      83
      132 Population          1 <NA>         log_M            parameter      84
      133 Population          1 <NA>         log_M            parameter      85
      134 Population          1 <NA>         log_M            parameter      86
      135 Population          1 <NA>         log_M            parameter      87
      136 Population          1 <NA>         log_M            parameter      88
      137 Population          1 <NA>         log_M            parameter      89
      138 Population          1 <NA>         log_M            parameter      90
      139 Population          1 <NA>         log_M            parameter      91
      140 Population          1 <NA>         log_M            parameter      92
      141 Population          1 <NA>         log_M            parameter      93
      142 Population          1 <NA>         log_M            parameter      94
      143 Population          1 <NA>         log_M            parameter      95
      144 Population          1 <NA>         log_M            parameter      96
      145 Population          1 <NA>         log_M            parameter      97
      146 Population          1 <NA>         log_M            parameter      98
      147 Population          1 <NA>         log_M            parameter      99
      148 Population          1 <NA>         log_M            parameter     100
      149 Population          1 <NA>         log_M            parameter     101
      150 Population          1 <NA>         log_M            parameter     102
      151 Population          1 <NA>         log_M            parameter     103
      152 Population          1 <NA>         log_M            parameter     104
      153 Population          1 <NA>         log_M            parameter     105
      154 Population          1 <NA>         log_M            parameter     106
      155 Population          1 <NA>         log_M            parameter     107
      156 Population          1 <NA>         log_M            parameter     108
      157 Population          1 <NA>         log_M            parameter     109
      158 Population          1 <NA>         log_M            parameter     110
      159 Population          1 <NA>         log_M            parameter     111
      160 Population          1 <NA>         log_M            parameter     112
      161 Population          1 <NA>         log_M            parameter     113
      162 Population          1 <NA>         log_M            parameter     114
      163 Population          1 <NA>         log_M            parameter     115
      164 Population          1 <NA>         log_M            parameter     116
      165 Population          1 <NA>         log_M            parameter     117
      166 Population          1 <NA>         log_M            parameter     118
      167 Population          1 <NA>         log_M            parameter     119
      168 Population          1 <NA>         log_M            parameter     120
      169 Population          1 <NA>         log_M            parameter     121
      170 Population          1 <NA>         log_M            parameter     122
      171 Population          1 <NA>         log_M            parameter     123
      172 Population          1 <NA>         log_M            parameter     124
      173 Population          1 <NA>         log_M            parameter     125
      174 Population          1 <NA>         log_M            parameter     126
      175 Population          1 <NA>         log_M            parameter     127
      176 Population          1 <NA>         log_M            parameter     128
      177 Population          1 <NA>         log_M            parameter     129
      178 Population          1 <NA>         log_M            parameter     130
      179 Population          1 <NA>         log_M            parameter     131
      180 Population          1 <NA>         log_M            parameter     132
      181 Population          1 <NA>         log_M            parameter     133
      182 Population          1 <NA>         log_M            parameter     134
      183 Population          1 <NA>         log_M            parameter     135
      184 Population          1 <NA>         log_M            parameter     136
      185 Population          1 <NA>         log_M            parameter     137
      186 Population          1 <NA>         log_M            parameter     138
      187 Population          1 <NA>         log_M            parameter     139
      188 Population          1 <NA>         log_M            parameter     140
      189 Population          1 <NA>         log_M            parameter     141
      190 Population          1 <NA>         log_M            parameter     142
      191 Population          1 <NA>         log_M            parameter     143
      192 Population          1 <NA>         log_M            parameter     144
      193 Population          1 <NA>         log_M            parameter     145
      194 Population          1 <NA>         log_M            parameter     146
      195 Population          1 <NA>         log_M            parameter     147
      196 Population          1 <NA>         log_M            parameter     148
      197 Population          1 <NA>         log_M            parameter     149
      198 Population          1 <NA>         log_M            parameter     150
      199 Population          1 <NA>         log_M            parameter     151
      200 Population          1 <NA>         log_M            parameter     152
      201 Population          1 <NA>         log_M            parameter     153
      202 Population          1 <NA>         log_M            parameter     154
      203 Population          1 <NA>         log_M            parameter     155
      204 Population          1 <NA>         log_M            parameter     156
      205 Population          1 <NA>         log_M            parameter     157
      206 Population          1 <NA>         log_M            parameter     158
      207 Population          1 <NA>         log_M            parameter     159
      208 Population          1 <NA>         log_M            parameter     160
      209 Population          1 <NA>         log_M            parameter     161
      210 Population          1 <NA>         log_M            parameter     162
      211 Population          1 <NA>         log_M            parameter     163
      212 Population          1 <NA>         log_M            parameter     164
      213 Population          1 <NA>         log_M            parameter     165
      214 Population          1 <NA>         log_M            parameter     166
      215 Population          1 <NA>         log_M            parameter     167
      216 Population          1 <NA>         log_M            parameter     168
      217 Population          1 <NA>         log_M            parameter     169
      218 Population          1 <NA>         log_M            parameter     170
      219 Population          1 <NA>         log_M            parameter     171
      220 Population          1 <NA>         log_M            parameter     172
      221 Population          1 <NA>         log_M            parameter     173
      222 Population          1 <NA>         log_M            parameter     174
      223 Population          1 <NA>         log_M            parameter     175
      224 Population          1 <NA>         log_M            parameter     176
      225 Population          1 <NA>         log_M            parameter     177
      226 Population          1 <NA>         log_M            parameter     178
      227 Population          1 <NA>         log_M            parameter     179
      228 Population          1 <NA>         log_M            parameter     180
      229 Population          1 <NA>         log_M            parameter     181
      230 Population          1 <NA>         log_M            parameter     182
      231 Population          1 <NA>         log_M            parameter     183
      232 Population          1 <NA>         log_M            parameter     184
      233 Population          1 <NA>         log_M            parameter     185
      234 Population          1 <NA>         log_M            parameter     186
      235 Population          1 <NA>         log_M            parameter     187
      236 Population          1 <NA>         log_M            parameter     188
      237 Population          1 <NA>         log_M            parameter     189
      238 Population          1 <NA>         log_M            parameter     190
      239 Population          1 <NA>         log_M            parameter     191
      240 Population          1 <NA>         log_M            parameter     192
      241 Population          1 <NA>         log_M            parameter     193
      242 Population          1 <NA>         log_M            parameter     194
      243 Population          1 <NA>         log_M            parameter     195
      244 Population          1 <NA>         log_M            parameter     196
      245 Population          1 <NA>         log_M            parameter     197
      246 Population          1 <NA>         log_M            parameter     198
      247 Population          1 <NA>         log_M            parameter     199
      248 Population          1 <NA>         log_M            parameter     200
      249 Population          1 <NA>         log_M            parameter     201
      250 Population          1 <NA>         log_M            parameter     202
      251 Population          1 <NA>         log_M            parameter     203
      252 Population          1 <NA>         log_M            parameter     204
      253 Population          1 <NA>         log_M            parameter     205
      254 Population          1 <NA>         log_M            parameter     206
      255 Population          1 <NA>         log_M            parameter     207
      256 Population          1 <NA>         log_M            parameter     208
      257 Population          1 <NA>         log_M            parameter     209
      258 Population          1 <NA>         log_M            parameter     210
      259 Population          1 <NA>         log_M            parameter     211
      260 Population          1 <NA>         log_M            parameter     212
      261 Population          1 <NA>         log_M            parameter     213
      262 Population          1 <NA>         log_M            parameter     214
      263 Population          1 <NA>         log_M            parameter     215
      264 Population          1 <NA>         log_M            parameter     216
      265 Population          1 <NA>         log_M            parameter     217
      266 Population          1 <NA>         log_M            parameter     218
      267 Population          1 <NA>         log_M            parameter     219
      268 Population          1 <NA>         log_M            parameter     220
      269 Population          1 <NA>         log_M            parameter     221
      270 Population          1 <NA>         log_M            parameter     222
      271 Population          1 <NA>         log_M            parameter     223
      272 Population          1 <NA>         log_M            parameter     224
      273 Population          1 <NA>         log_M            parameter     225
      274 Population          1 <NA>         log_M            parameter     226
      275 Population          1 <NA>         log_M            parameter     227
      276 Population          1 <NA>         log_M            parameter     228
      277 Population          1 <NA>         log_M            parameter     229
      278 Population          1 <NA>         log_M            parameter     230
      279 Population          1 <NA>         log_M            parameter     231
      280 Population          1 <NA>         log_M            parameter     232
      281 Population          1 <NA>         log_M            parameter     233
      282 Population          1 <NA>         log_M            parameter     234
      283 Population          1 <NA>         log_M            parameter     235
      284 Population          1 <NA>         log_M            parameter     236
      285 Population          1 <NA>         log_M            parameter     237
      286 Population          1 <NA>         log_M            parameter     238
      287 Population          1 <NA>         log_M            parameter     239
      288 Population          1 <NA>         log_M            parameter     240
      289 Population          1 <NA>         log_M            parameter     241
      290 Population          1 <NA>         log_M            parameter     242
      291 Population          1 <NA>         log_M            parameter     243
      292 Population          1 <NA>         log_M            parameter     244
      293 Population          1 <NA>         log_M            parameter     245
      294 Population          1 <NA>         log_M            parameter     246
      295 Population          1 <NA>         log_M            parameter     247
      296 Population          1 <NA>         log_M            parameter     248
      297 Population          1 <NA>         log_M            parameter     249
      298 Population          1 <NA>         log_M            parameter     250
      299 Population          1 <NA>         log_M            parameter     251
      300 Population          1 <NA>         log_M            parameter     252
      301 Population          1 <NA>         log_M            parameter     253
      302 Population          1 <NA>         log_M            parameter     254
      303 Population          1 <NA>         log_M            parameter     255
      304 Population          1 <NA>         log_M            parameter     256
      305 Population          1 <NA>         log_M            parameter     257
      306 Population          1 <NA>         log_M            parameter     258
      307 Population          1 <NA>         log_M            parameter     259
      308 Population          1 <NA>         log_M            parameter     260
      309 Population          1 <NA>         log_M            parameter     261
      310 Population          1 <NA>         log_M            parameter     262
      311 Population          1 <NA>         log_M            parameter     263
      312 Population          1 <NA>         log_M            parameter     264
      313 Population          1 <NA>         log_M            parameter     265
      314 Population          1 <NA>         log_M            parameter     266
      315 Population          1 <NA>         log_M            parameter     267
      316 Population          1 <NA>         log_M            parameter     268
      317 Population          1 <NA>         log_M            parameter     269
      318 Population          1 <NA>         log_M            parameter     270
      319 Population          1 <NA>         log_M            parameter     271
      320 Population          1 <NA>         log_M            parameter     272
          parameter_id fleet   year_i   age length   input observed estimation_type
                 <int> <chr>    <int> <dbl>  <dbl>   <dbl>    <dbl> <chr>
        1            1 fleet1      NA    NA     NA  1.94         NA fixed_effects
        2            2 survey1     NA    NA     NA  1.53         NA fixed_effects
        3            3 fleet1      NA    NA     NA  0.986        NA fixed_effects
        4            4 survey1     NA    NA     NA  2.00         NA fixed_effects
        5           13 <NA>        NA    NA     NA 13.8          NA fixed_effects
        6           14 <NA>        NA    NA     NA  0.788        NA constant
        7           15 <NA>         2    NA     NA  0.421        NA random_effects
        8           16 <NA>         3    NA     NA -0.184        NA random_effects
        9           17 <NA>         4    NA     NA -0.417        NA random_effects
       10           18 <NA>         5    NA     NA  0.636        NA random_effects
       11           19 <NA>         6    NA     NA  0.340        NA random_effects
       12           20 <NA>         7    NA     NA -0.0743       NA random_effects
       13           21 <NA>         8    NA     NA  0.337        NA random_effects
       14           22 <NA>         9    NA     NA -0.0581       NA random_effects
       15           23 <NA>        10    NA     NA  0.158        NA random_effects
       16           24 <NA>        11    NA     NA  0.0672       NA random_effects
       17           25 <NA>        12    NA     NA -0.295        NA random_effects
       18           26 <NA>        13    NA     NA -0.0216       NA random_effects
       19           27 <NA>        14    NA     NA  0.133        NA random_effects
       20           28 <NA>        15    NA     NA -0.0698       NA random_effects
       21           29 <NA>        16    NA     NA  0.204        NA random_effects
       22           30 <NA>        17    NA     NA  0.181        NA random_effects
       23           31 <NA>        18    NA     NA -0.435        NA random_effects
       24           32 <NA>        19    NA     NA -0.252        NA random_effects
       25           33 <NA>        20    NA     NA -0.601        NA random_effects
       26           34 <NA>        21    NA     NA  0.376        NA random_effects
       27           35 <NA>        22    NA     NA  0.293        NA random_effects
       28           36 <NA>        23    NA     NA -0.255        NA random_effects
       29           37 <NA>        24    NA     NA -0.550        NA random_effects
       30           38 <NA>        25    NA     NA  0.103        NA random_effects
       31           39 <NA>        26    NA     NA -0.496        NA random_effects
       32           40 <NA>        27    NA     NA -0.125        NA random_effects
       33           41 <NA>        28    NA     NA  0.197        NA random_effects
       34           42 <NA>        29    NA     NA  0.427        NA random_effects
       35           43 <NA>        30    NA     NA -0.185        NA random_effects
       36           73 <NA>        NA    NA     NA -1.13         NA fixed_effects
       37           74 <NA>        NA     1     NA 13.8          NA fixed_effects
       38           75 <NA>        NA     2     NA 13.7          NA fixed_effects
       39           76 <NA>        NA     3     NA 13.4          NA fixed_effects
       40           77 <NA>        NA     4     NA 13.2          NA fixed_effects
       41           78 <NA>        NA     5     NA 12.9          NA fixed_effects
       42           79 <NA>        NA     6     NA 12.8          NA fixed_effects
       43           80 <NA>        NA     7     NA 12.7          NA fixed_effects
       44           81 <NA>        NA     8     NA 12.2          NA fixed_effects
       45           82 <NA>        NA     9     NA 12.0          NA fixed_effects
       46           83 <NA>        NA    10     NA 11.9          NA fixed_effects
       47           84 <NA>        NA    11     NA 11.8          NA fixed_effects
       48           85 <NA>        NA    12     NA 13.1          NA fixed_effects
       49           86 <NA>         1     1     NA -1.61         NA constant
       50          116 <NA>         1     2     NA -1.61         NA constant
       51          146 <NA>         1     3     NA -1.61         NA constant
       52          176 <NA>         1     4     NA -1.61         NA constant
       53          206 <NA>         1     5     NA -1.61         NA constant
       54          236 <NA>         1     6     NA -1.61         NA constant
       55          266 <NA>         1     7     NA -1.61         NA constant
       56          296 <NA>         1     8     NA -1.61         NA constant
       57          326 <NA>         1     9     NA -1.61         NA constant
       58          356 <NA>         1    10     NA -1.61         NA constant
       59          386 <NA>         1    11     NA -1.61         NA constant
       60          416 <NA>         1    12     NA -1.61         NA constant
       61           87 <NA>         2     1     NA -1.61         NA constant
       62          117 <NA>         2     2     NA -1.61         NA constant
       63          147 <NA>         2     3     NA -1.61         NA constant
       64          177 <NA>         2     4     NA -1.61         NA constant
       65          207 <NA>         2     5     NA -1.61         NA constant
       66          237 <NA>         2     6     NA -1.61         NA constant
       67          267 <NA>         2     7     NA -1.61         NA constant
       68          297 <NA>         2     8     NA -1.61         NA constant
       69          327 <NA>         2     9     NA -1.61         NA constant
       70          357 <NA>         2    10     NA -1.61         NA constant
       71          387 <NA>         2    11     NA -1.61         NA constant
       72          417 <NA>         2    12     NA -1.61         NA constant
       73           88 <NA>         3     1     NA -1.61         NA constant
       74          118 <NA>         3     2     NA -1.61         NA constant
       75          148 <NA>         3     3     NA -1.61         NA constant
       76          178 <NA>         3     4     NA -1.61         NA constant
       77          208 <NA>         3     5     NA -1.61         NA constant
       78          238 <NA>         3     6     NA -1.61         NA constant
       79          268 <NA>         3     7     NA -1.61         NA constant
       80          298 <NA>         3     8     NA -1.61         NA constant
       81          328 <NA>         3     9     NA -1.61         NA constant
       82          358 <NA>         3    10     NA -1.61         NA constant
       83          388 <NA>         3    11     NA -1.61         NA constant
       84          418 <NA>         3    12     NA -1.61         NA constant
       85           89 <NA>         4     1     NA -1.61         NA constant
       86          119 <NA>         4     2     NA -1.61         NA constant
       87          149 <NA>         4     3     NA -1.61         NA constant
       88          179 <NA>         4     4     NA -1.61         NA constant
       89          209 <NA>         4     5     NA -1.61         NA constant
       90          239 <NA>         4     6     NA -1.61         NA constant
       91          269 <NA>         4     7     NA -1.61         NA constant
       92          299 <NA>         4     8     NA -1.61         NA constant
       93          329 <NA>         4     9     NA -1.61         NA constant
       94          359 <NA>         4    10     NA -1.61         NA constant
       95          389 <NA>         4    11     NA -1.61         NA constant
       96          419 <NA>         4    12     NA -1.61         NA constant
       97           90 <NA>         5     1     NA -1.61         NA constant
       98          120 <NA>         5     2     NA -1.61         NA constant
       99          150 <NA>         5     3     NA -1.61         NA constant
      100          180 <NA>         5     4     NA -1.61         NA constant
      101          210 <NA>         5     5     NA -1.61         NA constant
      102          240 <NA>         5     6     NA -1.61         NA constant
      103          270 <NA>         5     7     NA -1.61         NA constant
      104          300 <NA>         5     8     NA -1.61         NA constant
      105          330 <NA>         5     9     NA -1.61         NA constant
      106          360 <NA>         5    10     NA -1.61         NA constant
      107          390 <NA>         5    11     NA -1.61         NA constant
      108          420 <NA>         5    12     NA -1.61         NA constant
      109           91 <NA>         6     1     NA -1.61         NA constant
      110          121 <NA>         6     2     NA -1.61         NA constant
      111          151 <NA>         6     3     NA -1.61         NA constant
      112          181 <NA>         6     4     NA -1.61         NA constant
      113          211 <NA>         6     5     NA -1.61         NA constant
      114          241 <NA>         6     6     NA -1.61         NA constant
      115          271 <NA>         6     7     NA -1.61         NA constant
      116          301 <NA>         6     8     NA -1.61         NA constant
      117          331 <NA>         6     9     NA -1.61         NA constant
      118          361 <NA>         6    10     NA -1.61         NA constant
      119          391 <NA>         6    11     NA -1.61         NA constant
      120          421 <NA>         6    12     NA -1.61         NA constant
      121           92 <NA>         7     1     NA -1.61         NA constant
      122          122 <NA>         7     2     NA -1.61         NA constant
      123          152 <NA>         7     3     NA -1.61         NA constant
      124          182 <NA>         7     4     NA -1.61         NA constant
      125          212 <NA>         7     5     NA -1.61         NA constant
      126          242 <NA>         7     6     NA -1.61         NA constant
      127          272 <NA>         7     7     NA -1.61         NA constant
      128          302 <NA>         7     8     NA -1.61         NA constant
      129          332 <NA>         7     9     NA -1.61         NA constant
      130          362 <NA>         7    10     NA -1.61         NA constant
      131          392 <NA>         7    11     NA -1.61         NA constant
      132          422 <NA>         7    12     NA -1.61         NA constant
      133           93 <NA>         8     1     NA -1.61         NA constant
      134          123 <NA>         8     2     NA -1.61         NA constant
      135          153 <NA>         8     3     NA -1.61         NA constant
      136          183 <NA>         8     4     NA -1.61         NA constant
      137          213 <NA>         8     5     NA -1.61         NA constant
      138          243 <NA>         8     6     NA -1.61         NA constant
      139          273 <NA>         8     7     NA -1.61         NA constant
      140          303 <NA>         8     8     NA -1.61         NA constant
      141          333 <NA>         8     9     NA -1.61         NA constant
      142          363 <NA>         8    10     NA -1.61         NA constant
      143          393 <NA>         8    11     NA -1.61         NA constant
      144          423 <NA>         8    12     NA -1.61         NA constant
      145           94 <NA>         9     1     NA -1.61         NA constant
      146          124 <NA>         9     2     NA -1.61         NA constant
      147          154 <NA>         9     3     NA -1.61         NA constant
      148          184 <NA>         9     4     NA -1.61         NA constant
      149          214 <NA>         9     5     NA -1.61         NA constant
      150          244 <NA>         9     6     NA -1.61         NA constant
      151          274 <NA>         9     7     NA -1.61         NA constant
      152          304 <NA>         9     8     NA -1.61         NA constant
      153          334 <NA>         9     9     NA -1.61         NA constant
      154          364 <NA>         9    10     NA -1.61         NA constant
      155          394 <NA>         9    11     NA -1.61         NA constant
      156          424 <NA>         9    12     NA -1.61         NA constant
      157           95 <NA>        10     1     NA -1.61         NA constant
      158          125 <NA>        10     2     NA -1.61         NA constant
      159          155 <NA>        10     3     NA -1.61         NA constant
      160          185 <NA>        10     4     NA -1.61         NA constant
      161          215 <NA>        10     5     NA -1.61         NA constant
      162          245 <NA>        10     6     NA -1.61         NA constant
      163          275 <NA>        10     7     NA -1.61         NA constant
      164          305 <NA>        10     8     NA -1.61         NA constant
      165          335 <NA>        10     9     NA -1.61         NA constant
      166          365 <NA>        10    10     NA -1.61         NA constant
      167          395 <NA>        10    11     NA -1.61         NA constant
      168          425 <NA>        10    12     NA -1.61         NA constant
      169           96 <NA>        11     1     NA -1.61         NA constant
      170          126 <NA>        11     2     NA -1.61         NA constant
      171          156 <NA>        11     3     NA -1.61         NA constant
      172          186 <NA>        11     4     NA -1.61         NA constant
      173          216 <NA>        11     5     NA -1.61         NA constant
      174          246 <NA>        11     6     NA -1.61         NA constant
      175          276 <NA>        11     7     NA -1.61         NA constant
      176          306 <NA>        11     8     NA -1.61         NA constant
      177          336 <NA>        11     9     NA -1.61         NA constant
      178          366 <NA>        11    10     NA -1.61         NA constant
      179          396 <NA>        11    11     NA -1.61         NA constant
      180          426 <NA>        11    12     NA -1.61         NA constant
      181           97 <NA>        12     1     NA -1.61         NA constant
      182          127 <NA>        12     2     NA -1.61         NA constant
      183          157 <NA>        12     3     NA -1.61         NA constant
      184          187 <NA>        12     4     NA -1.61         NA constant
      185          217 <NA>        12     5     NA -1.61         NA constant
      186          247 <NA>        12     6     NA -1.61         NA constant
      187          277 <NA>        12     7     NA -1.61         NA constant
      188          307 <NA>        12     8     NA -1.61         NA constant
      189          337 <NA>        12     9     NA -1.61         NA constant
      190          367 <NA>        12    10     NA -1.61         NA constant
      191          397 <NA>        12    11     NA -1.61         NA constant
      192          427 <NA>        12    12     NA -1.61         NA constant
      193           98 <NA>        13     1     NA -1.61         NA constant
      194          128 <NA>        13     2     NA -1.61         NA constant
      195          158 <NA>        13     3     NA -1.61         NA constant
      196          188 <NA>        13     4     NA -1.61         NA constant
      197          218 <NA>        13     5     NA -1.61         NA constant
      198          248 <NA>        13     6     NA -1.61         NA constant
      199          278 <NA>        13     7     NA -1.61         NA constant
      200          308 <NA>        13     8     NA -1.61         NA constant
      201          338 <NA>        13     9     NA -1.61         NA constant
      202          368 <NA>        13    10     NA -1.61         NA constant
      203          398 <NA>        13    11     NA -1.61         NA constant
      204          428 <NA>        13    12     NA -1.61         NA constant
      205           99 <NA>        14     1     NA -1.61         NA constant
      206          129 <NA>        14     2     NA -1.61         NA constant
      207          159 <NA>        14     3     NA -1.61         NA constant
      208          189 <NA>        14     4     NA -1.61         NA constant
      209          219 <NA>        14     5     NA -1.61         NA constant
      210          249 <NA>        14     6     NA -1.61         NA constant
      211          279 <NA>        14     7     NA -1.61         NA constant
      212          309 <NA>        14     8     NA -1.61         NA constant
      213          339 <NA>        14     9     NA -1.61         NA constant
      214          369 <NA>        14    10     NA -1.61         NA constant
      215          399 <NA>        14    11     NA -1.61         NA constant
      216          429 <NA>        14    12     NA -1.61         NA constant
      217          100 <NA>        15     1     NA -1.61         NA constant
      218          130 <NA>        15     2     NA -1.61         NA constant
      219          160 <NA>        15     3     NA -1.61         NA constant
      220          190 <NA>        15     4     NA -1.61         NA constant
      221          220 <NA>        15     5     NA -1.61         NA constant
      222          250 <NA>        15     6     NA -1.61         NA constant
      223          280 <NA>        15     7     NA -1.61         NA constant
      224          310 <NA>        15     8     NA -1.61         NA constant
      225          340 <NA>        15     9     NA -1.61         NA constant
      226          370 <NA>        15    10     NA -1.61         NA constant
      227          400 <NA>        15    11     NA -1.61         NA constant
      228          430 <NA>        15    12     NA -1.61         NA constant
      229          101 <NA>        16     1     NA -1.61         NA constant
      230          131 <NA>        16     2     NA -1.61         NA constant
      231          161 <NA>        16     3     NA -1.61         NA constant
      232          191 <NA>        16     4     NA -1.61         NA constant
      233          221 <NA>        16     5     NA -1.61         NA constant
      234          251 <NA>        16     6     NA -1.61         NA constant
      235          281 <NA>        16     7     NA -1.61         NA constant
      236          311 <NA>        16     8     NA -1.61         NA constant
      237          341 <NA>        16     9     NA -1.61         NA constant
      238          371 <NA>        16    10     NA -1.61         NA constant
      239          401 <NA>        16    11     NA -1.61         NA constant
      240          431 <NA>        16    12     NA -1.61         NA constant
      241          102 <NA>        17     1     NA -1.61         NA constant
      242          132 <NA>        17     2     NA -1.61         NA constant
      243          162 <NA>        17     3     NA -1.61         NA constant
      244          192 <NA>        17     4     NA -1.61         NA constant
      245          222 <NA>        17     5     NA -1.61         NA constant
      246          252 <NA>        17     6     NA -1.61         NA constant
      247          282 <NA>        17     7     NA -1.61         NA constant
      248          312 <NA>        17     8     NA -1.61         NA constant
      249          342 <NA>        17     9     NA -1.61         NA constant
      250          372 <NA>        17    10     NA -1.61         NA constant
      251          402 <NA>        17    11     NA -1.61         NA constant
      252          432 <NA>        17    12     NA -1.61         NA constant
      253          103 <NA>        18     1     NA -1.61         NA constant
      254          133 <NA>        18     2     NA -1.61         NA constant
      255          163 <NA>        18     3     NA -1.61         NA constant
      256          193 <NA>        18     4     NA -1.61         NA constant
      257          223 <NA>        18     5     NA -1.61         NA constant
      258          253 <NA>        18     6     NA -1.61         NA constant
      259          283 <NA>        18     7     NA -1.61         NA constant
      260          313 <NA>        18     8     NA -1.61         NA constant
      261          343 <NA>        18     9     NA -1.61         NA constant
      262          373 <NA>        18    10     NA -1.61         NA constant
      263          403 <NA>        18    11     NA -1.61         NA constant
      264          433 <NA>        18    12     NA -1.61         NA constant
      265          104 <NA>        19     1     NA -1.61         NA constant
      266          134 <NA>        19     2     NA -1.61         NA constant
      267          164 <NA>        19     3     NA -1.61         NA constant
      268          194 <NA>        19     4     NA -1.61         NA constant
      269          224 <NA>        19     5     NA -1.61         NA constant
      270          254 <NA>        19     6     NA -1.61         NA constant
      271          284 <NA>        19     7     NA -1.61         NA constant
      272          314 <NA>        19     8     NA -1.61         NA constant
      273          344 <NA>        19     9     NA -1.61         NA constant
      274          374 <NA>        19    10     NA -1.61         NA constant
      275          404 <NA>        19    11     NA -1.61         NA constant
      276          434 <NA>        19    12     NA -1.61         NA constant
      277          105 <NA>        20     1     NA -1.61         NA constant
      278          135 <NA>        20     2     NA -1.61         NA constant
      279          165 <NA>        20     3     NA -1.61         NA constant
      280          195 <NA>        20     4     NA -1.61         NA constant
      281          225 <NA>        20     5     NA -1.61         NA constant
      282          255 <NA>        20     6     NA -1.61         NA constant
      283          285 <NA>        20     7     NA -1.61         NA constant
      284          315 <NA>        20     8     NA -1.61         NA constant
      285          345 <NA>        20     9     NA -1.61         NA constant
      286          375 <NA>        20    10     NA -1.61         NA constant
      287          405 <NA>        20    11     NA -1.61         NA constant
      288          435 <NA>        20    12     NA -1.61         NA constant
      289          106 <NA>        21     1     NA -1.61         NA constant
      290          136 <NA>        21     2     NA -1.61         NA constant
      291          166 <NA>        21     3     NA -1.61         NA constant
      292          196 <NA>        21     4     NA -1.61         NA constant
      293          226 <NA>        21     5     NA -1.61         NA constant
      294          256 <NA>        21     6     NA -1.61         NA constant
      295          286 <NA>        21     7     NA -1.61         NA constant
      296          316 <NA>        21     8     NA -1.61         NA constant
      297          346 <NA>        21     9     NA -1.61         NA constant
      298          376 <NA>        21    10     NA -1.61         NA constant
      299          406 <NA>        21    11     NA -1.61         NA constant
      300          436 <NA>        21    12     NA -1.61         NA constant
      301          107 <NA>        22     1     NA -1.61         NA constant
      302          137 <NA>        22     2     NA -1.61         NA constant
      303          167 <NA>        22     3     NA -1.61         NA constant
      304          197 <NA>        22     4     NA -1.61         NA constant
      305          227 <NA>        22     5     NA -1.61         NA constant
      306          257 <NA>        22     6     NA -1.61         NA constant
      307          287 <NA>        22     7     NA -1.61         NA constant
      308          317 <NA>        22     8     NA -1.61         NA constant
      309          347 <NA>        22     9     NA -1.61         NA constant
      310          377 <NA>        22    10     NA -1.61         NA constant
      311          407 <NA>        22    11     NA -1.61         NA constant
      312          437 <NA>        22    12     NA -1.61         NA constant
      313          108 <NA>        23     1     NA -1.61         NA constant
      314          138 <NA>        23     2     NA -1.61         NA constant
      315          168 <NA>        23     3     NA -1.61         NA constant
      316          198 <NA>        23     4     NA -1.61         NA constant
      317          228 <NA>        23     5     NA -1.61         NA constant
      318          258 <NA>        23     6     NA -1.61         NA constant
      319          288 <NA>        23     7     NA -1.61         NA constant
      320          318 <NA>        23     8     NA -1.61         NA constant
          distribution input_type      lpdf log_sd
          <chr>        <chr>          <dbl>  <dbl>
        1 <NA>         fixed_effects     NA     NA
        2 <NA>         fixed_effects     NA     NA
        3 <NA>         fixed_effects     NA     NA
        4 <NA>         fixed_effects     NA     NA
        5 <NA>         fixed_effects     NA     NA
        6 <NA>         constant          NA     NA
        7 normal       random_effects    NA     NA
        8 normal       random_effects    NA     NA
        9 normal       random_effects    NA     NA
       10 normal       random_effects    NA     NA
       11 normal       random_effects    NA     NA
       12 normal       random_effects    NA     NA
       13 normal       random_effects    NA     NA
       14 normal       random_effects    NA     NA
       15 normal       random_effects    NA     NA
       16 normal       random_effects    NA     NA
       17 normal       random_effects    NA     NA
       18 normal       random_effects    NA     NA
       19 normal       random_effects    NA     NA
       20 normal       random_effects    NA     NA
       21 normal       random_effects    NA     NA
       22 normal       random_effects    NA     NA
       23 normal       random_effects    NA     NA
       24 normal       random_effects    NA     NA
       25 normal       random_effects    NA     NA
       26 normal       random_effects    NA     NA
       27 normal       random_effects    NA     NA
       28 normal       random_effects    NA     NA
       29 normal       random_effects    NA     NA
       30 normal       random_effects    NA     NA
       31 normal       random_effects    NA     NA
       32 normal       random_effects    NA     NA
       33 normal       random_effects    NA     NA
       34 normal       random_effects    NA     NA
       35 normal       random_effects    NA     NA
       36 normal       fixed_effects     NA     NA
       37 <NA>         fixed_effects     NA     NA
       38 <NA>         fixed_effects     NA     NA
       39 <NA>         fixed_effects     NA     NA
       40 <NA>         fixed_effects     NA     NA
       41 <NA>         fixed_effects     NA     NA
       42 <NA>         fixed_effects     NA     NA
       43 <NA>         fixed_effects     NA     NA
       44 <NA>         fixed_effects     NA     NA
       45 <NA>         fixed_effects     NA     NA
       46 <NA>         fixed_effects     NA     NA
       47 <NA>         fixed_effects     NA     NA
       48 <NA>         fixed_effects     NA     NA
       49 <NA>         constant          NA     NA
       50 <NA>         constant          NA     NA
       51 <NA>         constant          NA     NA
       52 <NA>         constant          NA     NA
       53 <NA>         constant          NA     NA
       54 <NA>         constant          NA     NA
       55 <NA>         constant          NA     NA
       56 <NA>         constant          NA     NA
       57 <NA>         constant          NA     NA
       58 <NA>         constant          NA     NA
       59 <NA>         constant          NA     NA
       60 <NA>         constant          NA     NA
       61 <NA>         constant          NA     NA
       62 <NA>         constant          NA     NA
       63 <NA>         constant          NA     NA
       64 <NA>         constant          NA     NA
       65 <NA>         constant          NA     NA
       66 <NA>         constant          NA     NA
       67 <NA>         constant          NA     NA
       68 <NA>         constant          NA     NA
       69 <NA>         constant          NA     NA
       70 <NA>         constant          NA     NA
       71 <NA>         constant          NA     NA
       72 <NA>         constant          NA     NA
       73 <NA>         constant          NA     NA
       74 <NA>         constant          NA     NA
       75 <NA>         constant          NA     NA
       76 <NA>         constant          NA     NA
       77 <NA>         constant          NA     NA
       78 <NA>         constant          NA     NA
       79 <NA>         constant          NA     NA
       80 <NA>         constant          NA     NA
       81 <NA>         constant          NA     NA
       82 <NA>         constant          NA     NA
       83 <NA>         constant          NA     NA
       84 <NA>         constant          NA     NA
       85 <NA>         constant          NA     NA
       86 <NA>         constant          NA     NA
       87 <NA>         constant          NA     NA
       88 <NA>         constant          NA     NA
       89 <NA>         constant          NA     NA
       90 <NA>         constant          NA     NA
       91 <NA>         constant          NA     NA
       92 <NA>         constant          NA     NA
       93 <NA>         constant          NA     NA
       94 <NA>         constant          NA     NA
       95 <NA>         constant          NA     NA
       96 <NA>         constant          NA     NA
       97 <NA>         constant          NA     NA
       98 <NA>         constant          NA     NA
       99 <NA>         constant          NA     NA
      100 <NA>         constant          NA     NA
      101 <NA>         constant          NA     NA
      102 <NA>         constant          NA     NA
      103 <NA>         constant          NA     NA
      104 <NA>         constant          NA     NA
      105 <NA>         constant          NA     NA
      106 <NA>         constant          NA     NA
      107 <NA>         constant          NA     NA
      108 <NA>         constant          NA     NA
      109 <NA>         constant          NA     NA
      110 <NA>         constant          NA     NA
      111 <NA>         constant          NA     NA
      112 <NA>         constant          NA     NA
      113 <NA>         constant          NA     NA
      114 <NA>         constant          NA     NA
      115 <NA>         constant          NA     NA
      116 <NA>         constant          NA     NA
      117 <NA>         constant          NA     NA
      118 <NA>         constant          NA     NA
      119 <NA>         constant          NA     NA
      120 <NA>         constant          NA     NA
      121 <NA>         constant          NA     NA
      122 <NA>         constant          NA     NA
      123 <NA>         constant          NA     NA
      124 <NA>         constant          NA     NA
      125 <NA>         constant          NA     NA
      126 <NA>         constant          NA     NA
      127 <NA>         constant          NA     NA
      128 <NA>         constant          NA     NA
      129 <NA>         constant          NA     NA
      130 <NA>         constant          NA     NA
      131 <NA>         constant          NA     NA
      132 <NA>         constant          NA     NA
      133 <NA>         constant          NA     NA
      134 <NA>         constant          NA     NA
      135 <NA>         constant          NA     NA
      136 <NA>         constant          NA     NA
      137 <NA>         constant          NA     NA
      138 <NA>         constant          NA     NA
      139 <NA>         constant          NA     NA
      140 <NA>         constant          NA     NA
      141 <NA>         constant          NA     NA
      142 <NA>         constant          NA     NA
      143 <NA>         constant          NA     NA
      144 <NA>         constant          NA     NA
      145 <NA>         constant          NA     NA
      146 <NA>         constant          NA     NA
      147 <NA>         constant          NA     NA
      148 <NA>         constant          NA     NA
      149 <NA>         constant          NA     NA
      150 <NA>         constant          NA     NA
      151 <NA>         constant          NA     NA
      152 <NA>         constant          NA     NA
      153 <NA>         constant          NA     NA
      154 <NA>         constant          NA     NA
      155 <NA>         constant          NA     NA
      156 <NA>         constant          NA     NA
      157 <NA>         constant          NA     NA
      158 <NA>         constant          NA     NA
      159 <NA>         constant          NA     NA
      160 <NA>         constant          NA     NA
      161 <NA>         constant          NA     NA
      162 <NA>         constant          NA     NA
      163 <NA>         constant          NA     NA
      164 <NA>         constant          NA     NA
      165 <NA>         constant          NA     NA
      166 <NA>         constant          NA     NA
      167 <NA>         constant          NA     NA
      168 <NA>         constant          NA     NA
      169 <NA>         constant          NA     NA
      170 <NA>         constant          NA     NA
      171 <NA>         constant          NA     NA
      172 <NA>         constant          NA     NA
      173 <NA>         constant          NA     NA
      174 <NA>         constant          NA     NA
      175 <NA>         constant          NA     NA
      176 <NA>         constant          NA     NA
      177 <NA>         constant          NA     NA
      178 <NA>         constant          NA     NA
      179 <NA>         constant          NA     NA
      180 <NA>         constant          NA     NA
      181 <NA>         constant          NA     NA
      182 <NA>         constant          NA     NA
      183 <NA>         constant          NA     NA
      184 <NA>         constant          NA     NA
      185 <NA>         constant          NA     NA
      186 <NA>         constant          NA     NA
      187 <NA>         constant          NA     NA
      188 <NA>         constant          NA     NA
      189 <NA>         constant          NA     NA
      190 <NA>         constant          NA     NA
      191 <NA>         constant          NA     NA
      192 <NA>         constant          NA     NA
      193 <NA>         constant          NA     NA
      194 <NA>         constant          NA     NA
      195 <NA>         constant          NA     NA
      196 <NA>         constant          NA     NA
      197 <NA>         constant          NA     NA
      198 <NA>         constant          NA     NA
      199 <NA>         constant          NA     NA
      200 <NA>         constant          NA     NA
      201 <NA>         constant          NA     NA
      202 <NA>         constant          NA     NA
      203 <NA>         constant          NA     NA
      204 <NA>         constant          NA     NA
      205 <NA>         constant          NA     NA
      206 <NA>         constant          NA     NA
      207 <NA>         constant          NA     NA
      208 <NA>         constant          NA     NA
      209 <NA>         constant          NA     NA
      210 <NA>         constant          NA     NA
      211 <NA>         constant          NA     NA
      212 <NA>         constant          NA     NA
      213 <NA>         constant          NA     NA
      214 <NA>         constant          NA     NA
      215 <NA>         constant          NA     NA
      216 <NA>         constant          NA     NA
      217 <NA>         constant          NA     NA
      218 <NA>         constant          NA     NA
      219 <NA>         constant          NA     NA
      220 <NA>         constant          NA     NA
      221 <NA>         constant          NA     NA
      222 <NA>         constant          NA     NA
      223 <NA>         constant          NA     NA
      224 <NA>         constant          NA     NA
      225 <NA>         constant          NA     NA
      226 <NA>         constant          NA     NA
      227 <NA>         constant          NA     NA
      228 <NA>         constant          NA     NA
      229 <NA>         constant          NA     NA
      230 <NA>         constant          NA     NA
      231 <NA>         constant          NA     NA
      232 <NA>         constant          NA     NA
      233 <NA>         constant          NA     NA
      234 <NA>         constant          NA     NA
      235 <NA>         constant          NA     NA
      236 <NA>         constant          NA     NA
      237 <NA>         constant          NA     NA
      238 <NA>         constant          NA     NA
      239 <NA>         constant          NA     NA
      240 <NA>         constant          NA     NA
      241 <NA>         constant          NA     NA
      242 <NA>         constant          NA     NA
      243 <NA>         constant          NA     NA
      244 <NA>         constant          NA     NA
      245 <NA>         constant          NA     NA
      246 <NA>         constant          NA     NA
      247 <NA>         constant          NA     NA
      248 <NA>         constant          NA     NA
      249 <NA>         constant          NA     NA
      250 <NA>         constant          NA     NA
      251 <NA>         constant          NA     NA
      252 <NA>         constant          NA     NA
      253 <NA>         constant          NA     NA
      254 <NA>         constant          NA     NA
      255 <NA>         constant          NA     NA
      256 <NA>         constant          NA     NA
      257 <NA>         constant          NA     NA
      258 <NA>         constant          NA     NA
      259 <NA>         constant          NA     NA
      260 <NA>         constant          NA     NA
      261 <NA>         constant          NA     NA
      262 <NA>         constant          NA     NA
      263 <NA>         constant          NA     NA
      264 <NA>         constant          NA     NA
      265 <NA>         constant          NA     NA
      266 <NA>         constant          NA     NA
      267 <NA>         constant          NA     NA
      268 <NA>         constant          NA     NA
      269 <NA>         constant          NA     NA
      270 <NA>         constant          NA     NA
      271 <NA>         constant          NA     NA
      272 <NA>         constant          NA     NA
      273 <NA>         constant          NA     NA
      274 <NA>         constant          NA     NA
      275 <NA>         constant          NA     NA
      276 <NA>         constant          NA     NA
      277 <NA>         constant          NA     NA
      278 <NA>         constant          NA     NA
      279 <NA>         constant          NA     NA
      280 <NA>         constant          NA     NA
      281 <NA>         constant          NA     NA
      282 <NA>         constant          NA     NA
      283 <NA>         constant          NA     NA
      284 <NA>         constant          NA     NA
      285 <NA>         constant          NA     NA
      286 <NA>         constant          NA     NA
      287 <NA>         constant          NA     NA
      288 <NA>         constant          NA     NA
      289 <NA>         constant          NA     NA
      290 <NA>         constant          NA     NA
      291 <NA>         constant          NA     NA
      292 <NA>         constant          NA     NA
      293 <NA>         constant          NA     NA
      294 <NA>         constant          NA     NA
      295 <NA>         constant          NA     NA
      296 <NA>         constant          NA     NA
      297 <NA>         constant          NA     NA
      298 <NA>         constant          NA     NA
      299 <NA>         constant          NA     NA
      300 <NA>         constant          NA     NA
      301 <NA>         constant          NA     NA
      302 <NA>         constant          NA     NA
      303 <NA>         constant          NA     NA
      304 <NA>         constant          NA     NA
      305 <NA>         constant          NA     NA
      306 <NA>         constant          NA     NA
      307 <NA>         constant          NA     NA
      308 <NA>         constant          NA     NA
      309 <NA>         constant          NA     NA
      310 <NA>         constant          NA     NA
      311 <NA>         constant          NA     NA
      312 <NA>         constant          NA     NA
      313 <NA>         constant          NA     NA
      314 <NA>         constant          NA     NA
      315 <NA>         constant          NA     NA
      316 <NA>         constant          NA     NA
      317 <NA>         constant          NA     NA
      318 <NA>         constant          NA     NA
      319 <NA>         constant          NA     NA
      320 <NA>         constant          NA     NA
      # i 13,654 more rows

