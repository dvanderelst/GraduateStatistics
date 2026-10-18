# What share of "significant" findings report a real effect?
#
# Plug in four numbers and get the positive predictive value (PPV) from
# Ioannidis (2005).  Change the settings below and run again.
#
# p_e:   prior probability that a tested effect is real.  Ioannidis writes
#        this as odds R (real : not real); p_e = R / (R + 1).
# power: chance of p < alpha when the effect is real.
# alpha: chance of p < alpha when the effect is not real.
# u:     bias.  The share of analyses that should have come out negative but
#        are reported as findings anyway (flexible analysis, selective
#        reporting, ...).  u = 0 means no bias.

p_e <- 0.1
power <- 0.8
alpha <- 0.05
u <- 0.3

studies <- 1000        # tested relationships, to turn shares into counts

# ---------------------------------------------------------------- the calculation

# Bias turns a share u of the negative results into findings: among real
# effects, u of the misses (1 - power); among null effects, u of the correct
# negatives (1 - alpha).
found_if_real <- power + u * (1 - power)
found_if_null <- alpha + u * (1 - alpha)

ppv <- p_e * found_if_real / (p_e * found_if_real + (1 - p_e) * found_if_null)
ppv_no_bias <- p_e * power / (p_e * power + (1 - p_e) * alpha)

# The same, as counts.
real <- studies * p_e
null <- studies - real
true_findings <- real * found_if_real
false_findings <- null * found_if_null

# ---------------------------------------------------------------- the result

cat("settings: p_e =", p_e, " power =", power, " alpha =", alpha,
    " u =", u, "\n\n")

cat("Of", studies, "tested relationships:\n")
cat("  real effects            :", round(real), "\n")
cat("  -> reported as findings :", round(true_findings), "\n")
cat("  no effect               :", round(null), "\n")
cat("  -> reported as findings :", round(false_findings), "\n\n")

cat("PPV                       :", round(ppv, 3), "\n")
cat("PPV without bias (u = 0)  :", round(ppv_no_bias, 3), "\n")

# ---------------------------------------------------------------- the point

# Try the rows of Table 4 in Ioannidis (2005).  For example, an underpowered
# exploratory study: p_e = 1/11 (R = 1:10), power = 0.2, u = 0.3 gives a PPV
# of about 0.12.  Most of its findings are false.
