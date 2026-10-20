Exercise set: Bayesian reasoning and the hypothesis testing framework
================
BIOL8001 Graduate Statistics
2026-10-19



This set covers sections 5 and 6. For the calculations you can use R or
the scripts from class in the section 6 folder.

## Question 1: Two Questions About the Same Data

In class we saw Bem’s (2011) experiment on “feeling the future”. On each
trial, two curtains appeared on a screen and the participant guessed
which one hid a picture. The computer chose the picture’s position only
after the guess. For erotic pictures, participants guessed right 53.1%
of the time. To keep things simple, treat this as 637 correct guesses
out of 1,200 independent guesses. Call the probability of a correct
guess θ. If nobody can feel the future, θ = 0.5.

**(1a)** Before calculating anything, write down in plain words the
question Bayesian reasoning asks about these data, and the question the
hypothesis testing framework asks.

**(1b)** Now write each question in symbols, as the probability that
each framework calculates. Use the actual numbers of this experiment
where you can.

**(1c)** Run `TwoQuestions.R` with `prior_weight <- 0`, a flat prior.
The script shows each of its two numbers as a red area.

- **(1c.1)** Write down the p value and p(θ ≤ 0.5 \| D) that the script
  prints.
- **(1c.2)** Match each number to one of your probabilities from (1b).
- **(1c.3)** The two numbers are almost equal. Does that mean they tell
  you the same thing? Explain.

**(1d)** Now set `prior_weight <- 10000`: someone who is already quite
sure that people cannot feel the future. This setting gives a prior
centred on 0.5, as firm as if this person had already watched 10,000
guesses, half of them right. It changes the shape of the prior, not the
data.

- **(1d.1)** Run the script again and write down both numbers.
- **(1d.2)** Which number changed and which did not? Explain why one of
  them cannot respond to the prior.
- **(1d.3)** What does this tell you about reading a p value as the
  probability that the null hypothesis is true?

## Question 2: What Can a Probability Be About?

Bayesian reasoning and the hypothesis testing framework both calculate
probabilities, but they do not agree on what a probability is. The
hypothesis testing framework rests on the frequentist view: a
probability is the long-run frequency of a repeatable random process.
Bayesian reasoning also allows a probability to express how strongly we
believe something. As a result, some probabilities that make perfect
sense to a Bayesian are meaningless to a frequentist.

|  | Probability | Frequentist | Bayesian |
|----|----|----|----|
| 1 | The probability that the next flip of a fair coin lands heads. |  |  |
| 2 | The probability that a baby born in Paris between 1745 and 1770 was a boy. |  |  |
| 3 | The probability that θ, the share of boys among Paris births, is larger than 0.5. |  |  |
| 4 | The probability of seeing at least 251,527 boys among 493,472 births if θ = 0.5. |  |  |
| 5 | The probability that it is raining right now, given that the person who just walked by carried an umbrella. |  |  |
| 6 | The probability that the mean weight of the penguins in a colony is above 5 kg. |  |  |
| 7 | The probability that a 95% confidence interval computed from a new sample will contain the colony’s mean weight. |  |  |
| 8 | The probability that the defendant in a particular murder trial is guilty. |  |  |
| 9 | The probability that there has ever been life on Mars. |  |  |

**(2a)** For each probability, mark whether a frequentist would accept
it as meaningful, whether a Bayesian would, or both. For each one a
frequentist rejects, give the reason in one line.

**(2b)** Probabilities 2 and 3 are both about boys born in Paris.
Explain why a frequentist accepts one of them and rejects the other.

## Question 3: What a p Value Is Not

**(3a)** The three statements below are all false. For each, explain
why, and say what would be correct instead.

1.  A small p value shows that the null hypothesis is probably false.
2.  A large p value is strong evidence that the null hypothesis is true.
3.  A p value tells us how large or important an effect is.

**(3b)** Run `pValuesWithn.R`. Penguins on the two islands differ in
mean height by 1 mm, a difference nobody would care about.

- **(3b.1)** From the left panel, read off roughly from which sample
  size on most studies come out with p \< 0.05.
- **(3b.2)** A study with 30,000 penguins per island reports p \< 0.001.
  Which of the three statements in (3a) would lead you to misread this
  result? Explain what the result does tell you.

## Question 4: The Nurse and the Number

In 2001, a baby died at the Juliana Children’s Hospital in The Hague
while the nurse Lucia de Berk was on duty. A colleague told the hospital
that De Berk had been present at a suspiciously large number of deaths
and resuscitations, and the hospital went to the police. Investigators
went back through the records of her shifts, at Juliana and at hospitals
where she had worked before, and counted the “incidents” that had
occurred while she was working. An incident is a patient who needed
resuscitation, whether or not the patient survived. In 2003 De Berk was
convicted of four murders and three attempted murders and sentenced to
life in prison.

There was little medical evidence. Much of the case rested on a number.
An expert witness for the prosecution calculated that the chance of so
many incidents falling on her shifts by coincidence was **1 in 342
million**.

The expert used data from two hospitals: the Juliana Children’s
Hospital, where the suspicion arose, and the Red Cross Hospital (Rode
Kruis Ziekenhuis), where De Berk had worked before on two wards,
numbered 41 and 42. For each ward he counted all the shifts on that ward
during the period he studied, the shifts in which De Berk was on duty,
the incidents on the ward, and the incidents that happened during her
shifts. The table shows two of the three wards. (We leave out ward 41,
where she worked only a handful of shifts.) Each row is one ward where
De Berk worked. It compares her shifts with all the shifts on that ward.

| Ward | All shifts on the ward | Shifts De Berk worked | All incidents on the ward | Incidents during her shifts |
|----|----|----|----|----|
| Juliana Children’s | 1,029 | 142 | 8 | 8 |
| Red Cross, ward 42 | 339 | 58 | 14 | 5 |

`DeBerkShifts.R` runs a hypothesis test. Here the parameter is not a
number but a state of the world: De Berk is guilty or not guilty. The
null hypothesis is parameter = not guilty. In that case the incidents
have nothing to do with her: each incident lands on a shift picked at
random, whoever is working it. The script simulates 100,000 wards in
which this null hypothesis is true and counts how many incidents fall on
her shifts in each. The share of simulated wards with at least as many
incidents during her shifts as in reality is the **p value**:

$$\text{p value} = p(\text{incidents during her shifts} \geq \text{observed} \mid \text{parameter} = \text{not guilty})$$

This is the same kind of probability as the p value in Question 1, and
as p(two deaths \| not guilty) in the Sally Clark case from section 5.
The script also calculates it exactly, without simulating.

**(4a)** Run `DeBerkShifts.R` once for each ward, with
`ward <- "red cross 42"` and with `ward <- "juliana"`. Fill in the table
with the numbers the script prints.

| Ward | Simulated wards with at least as many incidents during her shifts (out of 100,000) | p value, simulated | p value, exact |
|----|----|----|----|
| Red Cross, ward 42 |  |  |  |
| Juliana Children’s |  |  |  |

For which ward is the p value below 0.05?

**(4b)** The expert’s 1 in 342 million had two problems.

- **(4b.1)** He combined the wards by multiplying their p values. Take a
  nurse whose number of incidents is perfectly ordinary on every ward
  she has worked on: p = 0.5 on each. Multiply the p values for four
  wards. What does the result suggest about her? Why is it wrong to read
  the product as a p value?
- **(4b.2)** The suspicion arose because someone noticed many incidents
  during De Berk’s shifts at Juliana. The expert then used those same
  Juliana incidents to calculate the p value. Think of a lottery: every
  week someone wins, even though each player’s chance of winning is
  tiny. Why would it be wrong to conclude from those tiny odds that the
  winner cheated? Apply the same reasoning to De Berk.

**(4c)** The court read the 1 in 342 million as the probability that De
Berk was not guilty. Write down in plain words what this probability was
meant to capture.

**(4d)** Over the years, the statistician Richard Gill and colleagues
built a better model. Among other things, it allows for the fact that
nurses differ in how many incidents happen on their shifts, for example
through their skills and the shifts and patients they take on. In 2018
they calculated that the probability of a pattern like De Berk’s arising
by chance is about **1 in 49**. Take this number as p(D \| not guilty),
where D stands for “a pattern at least as unusual as De Berk’s”. Write
Bayes’ theorem for the ratio p(not guilty \| D) / p(guilty \| D), as we
did for Sally Clark in section 5, and calculate it. For the other
numbers you need, assume that a nurse who kills patients would certainly
produce such a pattern, and that 1 in 100,000 nurses kills patients (a
made-up number). Then, in a country with 100,000 nurses, how many
innocent nurses would have a pattern at least as unusual as De Berk’s?
Compare this number with your ratio.

De Berk spent more than six years in prison. Statisticians, among them
Richard Gill and Peter Grünwald, reanalysed the data and campaigned for
the case to be reopened. One fact never carried weight in court: in the
three years before De Berk started on the Juliana ward, it had seven
deaths, and in the three years she worked there, six. In 2010 she was
acquitted: the court accepted that all the deaths had natural causes.

*Sources:* Buchanan, M. (2007). Conviction by numbers. *Nature*, 445,
254–255. O’Grady, C. (2023). Unlucky numbers. *Science*, 379, 228–233.
The shift table is from Meester, R., Collins, M., Gill, R., & van
Lambalgen, M. (2007). On the (ab)use of statistics in the legal case
against the nurse Lucia de B. *Law, Probability and Risk*, 5, 233–250.
The 1 in 49 is from Gill, R. D., Groeneboom, P., & de Jong, P. (2018).
Elementary statistics on trial: the case of Lucia de Berk. *Chance*,
31(4), 9–15.
