# Bad luck or a pattern?  Incidents on one nurse's shifts.
#
# A ward has a number of shifts, and makeone nurse worked some of them.  Over the
# same period the ward had a number of incidents (patients who needed
# resuscitation).  If the incidents have nothing to do with her, each one
# falls on whichever shift it happens to fall on, and her shifts get their
# share by chance.  How often would chance alone put as many incidents on her
# shifts as we saw?
#
# Numbers from the Lucia de Berk case (Meester et al., 2007).  Change the
# switch and run again.

ward <- "juliana"   # the switch: "red cross 42" or "juliana"

wards <- list("red cross 42" = c(shifts = 339,  her_shifts = 58,  incidents = 14, on_hers = 5),
              "juliana"      = c(shifts = 1029, her_shifts = 142, incidents = 8,  on_hers = 8))

shifts <- wards[[ward]]["shifts"]           # all shifts on the ward
her_shifts <- wards[[ward]]["her_shifts"]   # the shifts she worked
incidents <- wards[[ward]]["incidents"]     # incidents on the ward
on_hers <- wards[[ward]]["on_hers"]         # the data: incidents on her shifts

n_wards <- 100000      # how many chance-only wards to simulate

# ---------------------------------------------------------------- the worlds

# One simulated ward: every incident lands on a shift picked at random.
# Number the shifts so that hers are 1 to her_shifts, and count how many
# incidents land on those.
simulated <- numeric(n_wards)
for (i in 1:n_wards) {
  landed_on <- sample(1:shifts, incidents, replace = TRUE)
  simulated[i] <- sum(landed_on <= her_shifts)
}

# The p value: the share of chance-only wards with at least as many incidents
# on her shifts as the real one.
p_simulated <- mean(simulated >= on_hers)

# The same probability without simulating.  Each incident lands on one of her
# shifts with probability her_shifts / shifts, so the count follows a binomial
# distribution.
p_exact <- pbinom(on_hers - 1, incidents, her_shifts / shifts, lower.tail = FALSE)

# ---------------------------------------------------------------- the plot

counts <- table(factor(simulated, levels = 0:incidents))
colours <- ifelse(0:incidents >= on_hers, "red", "grey60")

barplot(counts, col = colours, border = NA,
        xlab = "incidents on her shifts", ylab = "simulated wards",
        main = paste0(ward, ": ", format(n_wards, big.mark = ",", scientific = FALSE),
                      " wards where only chance is at work"))
mtext(paste0("red: at least ", on_hers, " incidents on her shifts, as observed"),
      line = 0.3)

# ---------------------------------------------------------------- the point

# The p value answers one question: if chance alone decides where incidents
# land, how often would her shifts get this many?  It does not say how
# probable it is that chance alone was at work.
cat("ward                          :", ward, "\n")
cat("her share of the shifts       :", round(her_shifts / shifts, 3), "\n")
cat("incidents on her shifts       :", on_hers, "of", incidents, "\n")
cat("simulated wards with at least :", sum(simulated >= on_hers), "of",
    format(n_wards, big.mark = ",", scientific = FALSE), "\n")
cat("p value, simulated            :", signif(p_simulated, 3), "\n")
cat("p value, exact                :", signif(p_exact, 3),
    "  (1 in", format(round(1 / p_exact), big.mark = ","), ")\n")
