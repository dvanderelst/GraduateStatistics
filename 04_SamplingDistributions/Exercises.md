Exercise set: Sampling distributions
================
BIOL8001 Graduate Statistics
2026-09-16

For the calculations in this sheet you can use R, the scripts from
class, or two online calculators: one for the [normal
distribution](https://mabognar.github.io/apps/normal.html) and one for
the [t distribution](https://mabognar.github.io/apps/t.html).

## Question 1: The width of the sampling distribution

As we have seen, the standard deviation of the sampling distribution of
the mean is

$$\sigma_{\bar{x}} = \frac{\sigma}{\sqrt{n}}$$

which is smaller than the spread of the population itself for any sample
size bigger than one. The left panel shows a colony with μ = 80 kg and σ
= 12 kg. The right panel plots the sd of the sampling distribution
against `n` for that colony.

![](Exercises_files/figure-gfm/q1-se-1.png)<!-- -->

**(a)** Take the colony in the left panel. A single penguin weighing 90
kg is nothing unusual there, since it is less than one σ above the mean.
Now think about what has to happen for a sample of five penguins from
this colony to average 90 kg. Use the comparison to explain why the
sampling distribution is narrower than the population. Do not quote the
formula back.

**(b)** The curve drops steeply and then flattens. Using the figure or
the formula: how many penguins do you need to halve the width you get at
`n = 10`? And to halve it again?

**(c)** Each row below is a different variable in a different
population. The first four columns describe the population. The last
three describe the sampling distribution of the mean for samples of size
`n`.

| Variable | population mean μ | population sd σ | population shape | sample size n | mean of the sampling distribution | sd of the sampling distribution | shape of the sampling distribution |
|----|----|----|----|----|----|----|----|
| Flipper length (mm) | 190 | 8 | normal | 16 |  |  |  |
| Egg mass (g) | 95 | 12 | normal | 9 |  |  |  |
| Dive depth (m) | 40 | 15 | strongly skewed | 25 |  |  |  |
| Birds per colony | 500 | 100 | strongly skewed | 4 |  |  |  |

Fill in the last three cells. Mark each entry as exact, approximate, or
unknown, and give your reason for any entry that is not exact.

**(d)** For row 4, you want the probability that a sample of four
colonies averages more than 600 birds. Can you get it from a normal
curve (R or the normal calculator) with the mean and sd in your table?
Could you answer the same kind of question for row 3 that way, say the
probability that the mean dive depth exceeds 45 m?

## Question 2: Four colonies that agree on μ and on σ

The top row shows four colonies of 2000 penguins each. All four have a
mean of exactly 50 kg and a standard deviation of exactly 12 kg. The
second and third rows show the sampling distribution of the mean for
each colony at two sample sizes. The figure is made the same way as
`SameMeanSameSD.R`.

![](Exercises_files/figure-gfm/q2-shapes-1.png)<!-- -->

**(a)** The four colonies agree on both numbers we normally use to
summarise a population. What has the summary thrown away? Using the top
row, describe for one colony of your choice something a biologist would
want to know that μ and σ do not tell them. How does this relate to
Stephen J Gould’s essay [The Median Isn’t the
Message](https://journalofethics.ama-assn.org/article/median-isnt-message/2013-01)?

**(b)** Colony C has a mean of 50 kg, and almost no penguin in it weighs
anything close to 50 kg. Its sampling distribution of the mean is
nevertheless centred on 50. Is the sampling distribution then centred on
a lie? Say what the number 50 is a correct statement about, and what it
is not.

**(c)** Here are two separate statements about the sampling distribution
of the mean: (1) its mean is μ and its standard deviation is σ/√n, as in
Question 1, and (2) its shape is approximately normal, which is what the
central limit theorem says for large samples. Compare the four panels in
the middle row with each other, then compare the middle row with the
bottom row. For each claim, say whether it holds for all four colonies
at both sample sizes. One of the two claims does not always hold. Name
the panel where it fails most clearly, and explain why that panel looks
the way it does.

**(d)** A colleague says: “My measurements are clearly not normally
distributed, so none of this applies to my data.” Which distribution
does the normality claim in (c) refer to: the population, the one sample
they collected, or the sampling distribution? Answer using the figure,
and say what you would tell the colleague.

## Question 3: The mean is not the only statistic

A statistic is any number you calculate from a sample, so the mean is
not special. The median, the sd, the minimum and the maximum all have
sampling distributions too; `PenguinStatistics.R` draws them for the
penguins in `PenguinMean.R`. This question looks at one of them more
closely: the maximum. Each of the two figures below shows three colonies
of 2000 penguins (top row), the sampling distribution of the heaviest
penguin in a sample of five (middle row), and the cumulative
distributions of that heaviest penguin for all three colonies together
(bottom panel). A cumulative distribution gives, for every weight on the
horizontal axis, the proportion of samples whose heaviest penguin is at
or below that weight. The dashed black lines mark the heaviest penguin
in each colony. The red line marks a researcher’s observation: five
penguins, the heaviest of which weighs 70 kg.

In the first figure, all three colonies have the same shape: weights are
spread evenly from 20 kg up to the heaviest penguin, which weighs 60, 80
or 100 kg.

![](Exercises_files/figure-gfm/q3-max-maxima-1.png)<!-- -->

**(a)** Compare the top and middle rows. Where does the heaviest of five
sit relative to the heaviest penguin in the colony? Can a sample of five
ever produce a value on the other side of the dashed line? Suppose you
had to report the heaviest penguin in a colony and could only catch
five. What would you tell a reader about your number? Would catching 20
remove the problem, or only shrink it?

**(b)** Use the bottom panel to answer these for the researcher whose
heaviest penguin weighs 70 kg:

1.  Which colony can you rule out completely, and why?
2.  For the colony whose heaviest penguin weighs 80 kg, read off the
    proportion of samples whose heaviest penguin is 70 kg or lighter. Do
    the same for the 100 kg colony. (The values are 0.40 and 0.10.)
3.  Write one sentence that says exactly what 0.10 is the probability
    of. Make clear what is assumed and what is observed. Compare your
    sentence with the one you write in Question 6(a).

In the second figure, all three colonies range from exactly 20 kg to
exactly 100 kg, so they share the same heaviest penguin. They differ
only in how the weights in between are spread.

![](Exercises_files/figure-gfm/q3-max-shapes-1.png)<!-- -->

**(c)** For each of these three colonies, read off the proportion of
samples whose heaviest penguin is 70 kg or lighter. (The values are
0.80, 0.10 and 0.00.) All three colonies have a heaviest penguin of 100
kg. Why are the answers so different? A colleague says: “Our heaviest
penguin was only 70 kg, so the heaviest penguin in the colony is
probably not 100 kg.” What would the colleague have to assume about the
colony to back this up?

**(d)** Only the mean has a tidy formula (Question 1) for its sampling
distribution. None of the curves in this question came from a formula.
How were they made? (`PenguinStatistics.R` does the same for the mean,
median, sd, minimum and maximum. Say in one sentence what it is doing.)

**(e)** (Optional) For the colonies in the first figure, weights are
spread evenly between 20 kg and the heaviest penguin M, so the chance
that one penguin weighs 70 kg or less is (70 − 20)/(M − 20). Use this to
work out the chance that all five penguins in a sample weigh 70 kg or
less, and check your answer against the values in (b).

## Question 4: When σ is unknown

Everything so far assumed we knew the population standard deviation σ.
We almost never do. The first figure shows the t distribution: the
sampling distribution of

$$t = \frac{\bar{x} - \mu}{s/\sqrt{n}}$$

for samples of five penguins (`df` = 4), with a standard normal drawn on
top of it for comparison. Both are on the t axis, which counts standard
errors rather than kilograms. See `TCurve.R`.

![](Exercises_files/figure-gfm/q4-t-1.png)<!-- -->

The second figure shows the same t-curve with a kilogram ruler, for a
sample of five penguins with an observed sd of 12 kg and an assumed mean
of 50 kg. See `TAxisInKilograms.R`.

![](Exercises_files/figure-gfm/q4-rulers-1.png)<!-- -->

**(a)** In your own words, what problem does the t distribution solve?
Your answer should name the piece of information we lost and say what we
put in its place.

**(b)** Compare the two curves in the first figure. Where do they agree,
and where do they differ? For a normal population, $\bar{x}$ has an
exactly normal sampling distribution. Why doesn’t t? The t statistic
uses the sample sd instead of σ, and the sample sd changes from sample
to sample. Use that to explain why the t curve differs from the normal
in the way it does. (Hint: what happens to t when a sample happens to
give a sample sd much smaller than σ?)

**(c)** The hint in (b) points at samples whose sd comes out smaller
than σ. How often does that happen?

1.  Before calculating anything, guess: if you draw many samples of five
    from a normal population with σ = 12 kg, what fraction of them will
    have a sample sd below 12 kg?
2.  Check your guess by simulation. Draw 10,000 samples of five with
    `rnorm(5, 50, 12)`, calculate the `sd()` of each, and count how
    often it is below 12. Also calculate the average of the 10,000 sds,
    and the average of their squares (the variances).
3.  Compare the average sd with σ = 12, and the average variance with σ²
    = 144. Explain how both results can be true at once. (Hint: how far
    below σ can a sample sd go, and how far above it?)
4.  Repeat with samples of 2 and of 30. How does the fraction below σ
    change, and what does that suggest about which samples fill the
    tails of the t curve when `n` is small?

**(d)** For a normal distribution, 95% of the curve lies within about
1.96 standard errors of the centre. Find the corresponding number for
the t with `df` = 4 (use `TCurve.R`, R, the t calculator, or a table).
Then use the second figure to say what the difference between those two
numbers is worth **in kilograms** for this sample. Would you have called
that difference negligible before computing it?

**(e)** Run `TCurve.R` with `n <- 5` and then with `n <- 30`, and
compare the two curves. What happens, and why does the distinction
between the t and the normal stop mattering as the sample grows? Connect
this to what the sample sd is doing as `n` increases.

## Question 5: From a sampling distribution to a confidence interval

We did not cover this in class, but the questions contain sufficient
information to solve them.

A researcher catches five penguins from a large colony. Weights in this
colony are normally distributed, but the researcher knows neither the
colony’s mean nor its sd. The five weights are 89, 78, 65, 44, and 34
kg, so the sample mean is 62 kg, and the sample sd is about 22.9 kg. The
researcher writes: “The mean weight of this colony is 62 kg.”

**(a)** What is wrong with that sentence? Think about what a second
researcher would report after catching five different penguins. Of the
three kinds of distribution we have met (the population, the one sample,
the sampling distribution), which one tells you how far a sample mean
typically lands from the colony’s true mean? The researcher only has one
sample. What can they calculate from it to estimate the width of that
distribution?

**(b)** Recall the t statistic from Question 4:

$$t = \frac{\bar{x} - \mu}{s/\sqrt{n}}$$

Question 4(d) gave the value $t_{0.975,\,n-1}$ that leaves 95% of the
`df` = 4 curve in the middle. So in 95% of samples of five, t lands
between $-t_{0.975,\,n-1}$ and $t_{0.975,\,n-1}$. Multiply through by
$s/\sqrt{n}$, and this says that the sample mean lands within
$t_{0.975,\,n-1}$ estimated standard errors of μ:

$$|\bar{x} - \mu| \le t_{0.975,\,n-1} \cdot \frac{s}{\sqrt{n}}$$

The standard error $s/\sqrt{n}$ is calculated from that same sample. Now
turn this around. If $\bar{x}$ is within that distance of μ, then μ is
within the same distance of $\bar{x}$. This lets us build an interval
around the one number we actually have:

$$\bar{x} \pm t_{0.975,\,n-1} \cdot \frac{s}{\sqrt{n}}$$

In the sentence “in 95% of samples, μ lies within this distance of
$\bar{x}$”, which quantities change from sample to sample, and which
stays fixed?

**(c)** Work out this 95% confidence interval for the researcher’s five
penguins, in three steps:

1.  The margin of error, $t_{0.975,\,n-1} \cdot s/\sqrt{n}$.
2.  The lower limit of the interval.
3.  The upper limit of the interval.

Then rewrite the researcher’s sentence so that it is defensible.

**(d)** The figure below repeats the researcher’s study 50 times. Each
time it draws five penguins from the same colony and builds the interval
from (c). For the simulation, the colony has a mean of 50 kg and an sd
of 20 kg. The dashed line marks that true mean of 50 kg, which a real
researcher would never get to see. Intervals that miss it are drawn in
red.

![](Exercises_files/figure-gfm/q5-ci-1.png)<!-- -->

4 of the 50 intervals miss the true mean. The true mean stays put in
every repeat. What changes from one repeat to the next? So what exactly
is the “95%” a property of? Is it a property of any single interval in
the figure?

**(e)** Say whether each of these readings of the researcher’s interval
is defensible, and explain what is wrong with the ones that are not.
Compare them with the p-values in Question 6(b).

1.  There is a 95% probability that the colony’s mean lies inside this
    interval.
2.  95% of the penguins in the colony weigh something inside this
    interval.
3.  If many researchers each caught five penguins and built an interval
    this way, about 95% of their intervals would contain the colony’s
    mean.
4.  If the researcher caught five new penguins, there is a 95% chance
    their mean would fall inside this interval.

**(f)** The researcher goes back and catches 20 penguins, and the sample
sd comes out about the same. Roughly how much narrower will the interval
be? Two things make it narrower. Name both, and use Question 1(b) to say
which of them does most of the work. What does this mean for someone
deciding how many penguins to catch?

**(g)** The recipe in (b) gives an interval that contains μ in exactly
95% of samples, but only if the colony is normal: Student’s theorem,
which gives the t distribution, needs that assumption. What happens if
the colony is not normal? The figure below takes the four colonies from
Question 2, which all have a mean of 50 kg. For each colony and each
sample size, it builds 10,000 intervals the way you did in (c), and
records the percentage of intervals that contain 50 kg.

![](Exercises_files/figure-gfm/q5-coverage-1.png)<!-- -->

1.  For which colony is the label “95% interval” exactly right? For the
    other three, what does the formula give you instead?
2.  Which colony gives the worst intervals, and at which sample sizes?
    Look back at its sampling distribution for samples of two in
    Question 2, and suggest why.
3.  Which colony stays below 95% the longest as `n` grows? What feature
    of its shape might be responsible?
4.  Why do all four colonies get close to 95% for larger samples? Which
    result from class is doing the work there?
5.  A researcher does not know the shape of their colony and catches
    five penguins. Can they build an interval that is guaranteed to
    contain μ in 95% of samples? What are they assuming if they use the
    formula from (b) anyway?

## Question 6: Using a sampling distribution for inference

This is the calculation from the end of the slides. We assume a
population of penguins with μ = 5 kg and σ = 3 kg. We catch 15 of them,
and the sample mean is 6.15 kg. The figure shows the sampling
distribution under this assumption, with the observed mean marked.

![](Exercises_files/figure-gfm/q6-inference-1.png)<!-- -->

The shaded area is 0.06882.

**(a)** Write one sentence that says exactly what that number is the
probability of. Your sentence must make clear what is being assumed and
what is being observed, and it should be possible to tell from it that
the number is not a statement about a single penguin.

**(b)** Here are four readings of the same number. Decide for each
whether it is defensible, and say what is wrong with the ones that are
not.

1.  There is a 6.9% chance that the population mean is 5 kg.
2.  There is a 6.9% chance that the difference between 6.15 kg and 5 kg
    is just sampling variation.
3.  If μ really were 5 kg and σ really were 3 kg, and many research
    groups each weighed 15 penguins, about 7% of them would report a
    mean of 6.15 kg or more.
4.  The probability of getting a sample mean of exactly 6.15 kg is 6.9%.

**(c)** The question asked was about a mean of “6.15 kg **or larger**”.
Why is it phrased that way rather than asking about 6.15 kg itself?
(Question 4 of the previous exercise set is the relevant one here.)

**(d)** Keeping the same 15 penguins and the same observed mean of 6.15
kg, the slides redo the calculation assuming μ = 3 instead, and get
0.00002. Nothing about the penguins changed between the two
calculations. So what is the p-value a property of? Name every
ingredient it depends on.

**(e)** Suppose the same mean of 6.15 kg had come from 60 penguins
instead of 15, with μ = 5 and σ = 3 as before. Work out the new
probability (`NormalCurve.R` will draw it, or use R or the normal
calculator). What changed, and what did not? What does this suggest
about reporting a p-value without the sample size next to it?

**(f)** The slides stop here with the words “now what?” and take no
decision. To turn 0.06882 into a decision about the assumed population
(keep μ = 5 kg or reject it), you need a cut-off. What is that cut-off
usually called, and what does it stand for? Is it anywhere in the data,
and if not, where does it come from?

## Question 7: A statistic built from two samples

This question goes beyond what we did in class, and it is the one to
attempt last.

A questionnaire asks whether animal research is wrong, answered on a
7-point scale. Assume that in the population the mean for women is 5,
the mean for men is 4, and the standard deviation in both groups is
1.55. Twelve women and twelve men are selected at random, and we record
the difference between the two sample means.

**(a)** That difference is a statistic, calculated from a sample, so it
has a sampling distribution like everything else in this sheet. Before
calculating anything: where would that distribution be centred, and
would you expect it to be wider or narrower than the sampling
distribution of either group’s mean on its own? Say why.

**(b)** First write down the sampling distribution of each group’s mean:
its mean, its sd and its shape. Then look up how the difference between
two independent normal variables is distributed (for example in the
Wikipedia article on the [sum of normally distributed random
variables](https://en.wikipedia.org/wiki/Sum_of_normally_distributed_random_variables)),
and use it to get the sampling distribution of the difference. What is
the probability that the women’s sample mean comes out more than 1.5
points above the men’s? The variances add even though you are
subtracting the means. Why does subtracting not make the spread smaller?

**(c)** Check your answer by simulation. The code below draws 12 women
and 12 men from normal populations with the parameters above, records
the difference in means, and repeats this 10,000 times. Run it. How
close is the simulation to your calculation, and what would make it
closer?

``` r
repeats <- 10000
differences <- numeric(repeats)
for (i in 1:repeats)
{
  women <- rnorm(12, mean = 5, sd = 1.55)
  men <- rnorm(12, mean = 4, sd = 1.55)
  differences[i] <- mean(women) - mean(men)
}
hist(differences, breaks = 50)
mean(differences > 1.5)
```

**(d)** A study of this size finds a difference of 1.5 points. We know
the true difference is 1 point, but the researchers do not. Using the
idea from Question 5, build a 95% interval around their 1.5 (σ is known
here, so use the normal distribution rather than the t). Which
population differences are compatible with their result? What does this
say about how much a single study of 12 and 12 tells you about the size
of the difference?
