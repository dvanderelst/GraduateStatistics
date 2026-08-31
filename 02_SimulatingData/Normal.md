# Notes for the Normal distribution section

Working notes for the slides. All numbers here were checked in R; the code that
produced them is inlined so they can be re-run.

---

## 1. What does the Normal model?

For the other three you could name a mechanism:

| distribution | the process |
|---|---|
| Binomial | n independent yes/no trials, constant p — count the successes |
| Geometric | the same trials, kept going — count trials to the first success |
| Poisson | events at a constant rate in a continuum — count them per unit |

The Normal has no such entry. **It does not model a mechanism, it models an
operation: addition.**

Anything that is the sum of many small independent contributions, none of them
dominating, comes out Normal — and it does not matter what the contributions
themselves look like.

| what you add up | skew of one draw | skew of the sum of 40 |
|---|---|---|
| coin flips (0/1) | 0.88 | 0.128 |
| uniform | -0.01 | 0.010 |
| exponential (badly skewed) | 2.01 | 0.318 |
| only 1s and 100s | -0.01 | 0.011 |

The last row is the one to show. A variable that can *only* be 1 or 100 —
nothing in between, nothing remotely bell-shaped — and forty of them added
together is symmetric.

### The message: this inverts everything so far

Slides 21-23 said **the process determines the distribution**. Change the
coin's mechanics and the binomial dies.

The Normal says the opposite. **Add up enough small independent things and the
process stops mattering.** The contributions' own shapes wash out.

That is why it turns up everywhere, and why it is "special": it is not one more
entry in the catalogue, it is what the catalogue converges to.

### What that means in practice

It models **measurements** — height, weight, length, concentration, error —
because those are nearly always sums of many small causes. Penguin height is
hundreds of genes each nudging up or down, plus diet, plus developmental noise,
plus the ruler. None dominates, so it is Normal.

It is also why `sd` is a *free* parameter here when `lambda` and `p` were not.
You do not know how many contributions there are or how big they are, so their
combined magnitude has to be estimated rather than derived from the mean.

### Two honest caveats

- The Normal runs to minus infinity, and penguins have no negative heights. It
  is **always an approximation** — very good when the mean sits many sd above
  zero, bad when it does not.
- It fails when contributions **multiply** instead of adding, which gives a
  right-skewed lognormal. Common in biology (growth, concentrations,
  abundance), so this is the assumption violation worth naming — the exact
  parallel of the sticky coin.

---

## 2. What is the height of the curve?

It is a **probability density**: probability *per unit of x*. Not a
probability. Two facts settle it.

### It can exceed 1

| sd | peak height |
|---|---|
| 2 | 0.199 |
| 1 | 0.399 |
| 0.5 | 0.798 |
| 0.1 | **3.989** |

No probability does that.

### It changes when you change units

The same penguins, mean 75 cm, sd 5:

- height of the curve at the mean: **0.0798 per cm**
- the same birds measured in metres: **7.9788 per m**

Same birds, same distribution, height times 100. The *area* stays exactly 1
either way. So the height is a rate — probability per centimetre — and is
meaningless without naming the unit. Area is unit-free, and area is the
probability.

Hence `P(exactly 75.000 cm) = 0`, and the only answerable question is a range:
`P(74 < X < 76) = 0.1585`.

### Is it a likelihood?

Not as drawn on the slide, but the question is pointing at something real. It
is the *same formula* read two ways:

- **Vary x, hold the parameters fixed** — a density. Area 1. Asks *what data
  does this world produce?* This is the curve on the slide.
- **Hold x at the data observed, vary the parameters** — the likelihood. Does
  *not* integrate to 1. Asks *which worlds would have made this data
  probable?*

The height becomes a likelihood only once the observation is fixed and the
parameters are what moves — which is what happens in topic 5 when Bayes needs
p(data | parameter), and again at maximum likelihood in topic 8. Per the
naming policy, keep the word "likelihood" back until then.

Practical note worth saying out loud: R's `dnorm` is **d for density**;
`pnorm` gives the area. Students reach for `dnorm` when they want a
probability every time.

---

## 3. How the contributions' sd relates to the Normal's sd

**Variances add. Standard deviations do not.**

```
variance_total = sum of the individual variances       (independent contributions)
```

So for n contributions each of sd `sd_c`:

| | sd | check: sd_c = 3, n = 40 |
|---|---|---|
| one contribution | `sd_c` | 3 |
| **sum** of n | `sd_c * sqrt(n)` | 19.0 (predicted 18.97) |
| **average** of n | `sd_c / sqrt(n)` | 0.475 (predicted 0.474) |

Three things fall out.

### The sqrt(n) is the whole of topic 4

Adding 40 contributions of sd 3 gives sd 19, not 120 — noise grows by the
square root, so it accumulates more slowly than the total does. Read the other
way, the *average* of n things has sd `sd_c / sqrt(n)`. That is the standard
error, and the sampling distributions section is essentially this one line
unpacked.

Corollary worth saying out loud: **halving your uncertainty costs four times
the data.**

### It explains why "no single contribution dominates" is a real condition

Because variances add as squares, one large contribution takes over fast:

| contributions | total sd | share of variance from the big one |
|---|---|---|
| one of sd 3 + 39 of sd 1 | 6.9 | 19% |
| one of sd 10 + 39 of sd 1 | 11.8 | **72%** |
| one of sd 30 + 39 of sd 1 | 30.6 | **96%** |

By the last row the sum simply *is* the big contribution in disguise, and it
takes that contribution's shape rather than a Normal one.

### It derives the binomial variance already in use

- one coin flip has variance `p(1-p)` = 0.2275
- ten flips, variances add: `n*p*(1-p)` = 2.275
- simulated: 2.289

So `np(1-p)` stops being a formula to memorise and becomes "variances add, ten
times."

### Caveat, and it is a callback

Variances add **only if the contributions are independent**. Positive
dependence makes the total larger than the sum — which is exactly what the
sticky coin did in `CoinAssumptions.R`, running 2.7x the binomial sd at
`stickiness = 0.9`.

---

## Code behind the numbers

```r
# CLT is agnostic to what you add up
set.seed(1); reps <- 40000
srcs <- list("coin flips (0/1)"     = function(n) rbinom(n, 1, 0.3),
             "uniform"              = function(n) runif(n),
             "exponential (skewed)" = function(n) rexp(n, 1),
             "only 1s and 100s"     = function(n) sample(c(1,100), n, TRUE))
for (nm in names(srcs)) {
  f <- srcs[[nm]]
  one <- f(reps)
  s <- rowSums(matrix(f(reps * 40), ncol = 40))
  cat(nm, " one:", round(mean(((one-mean(one))/sd(one))^3), 2),
          " sum of 40:", round(mean(((s-mean(s))/sd(s))^3), 3), "\n")
}

# density is not a probability
for (s in c(2, 1, 0.5, 0.1)) cat("sd", s, "peak", round(dnorm(0,0,s), 3), "\n")
dnorm(75, 75, 5)        # 0.0798 per cm
dnorm(0.75, 0.75, 0.05) # 7.9788 per m
pnorm(76,75,5) - pnorm(74,75,5)   # 0.1585

# variances add
set.seed(1); x <- matrix(rnorm(100000 * 40, 0, 3), ncol = 40)
sd(rowSums(x))   # 19.0   = 3 * sqrt(40)
sd(rowMeans(x))  # 0.475  = 3 / sqrt(40)

# one contribution dominating
for (big in c(3, 10, 30)) {
  sds <- c(big, rep(1, 39))
  cat("big sd", big, " total", round(sqrt(sum(sds^2)), 1),
      " share", round(100*big^2/sum(sds^2)), "%\n")
}
```
