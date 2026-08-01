# BIOL8001: Syllabus

> [!NOTE]
>
> I reserve the right to update this syllabus as class needs arise. Be assured that I will communicate any changes to our schedule, syllabus or policies quickly and efficiently. The most up-to-date version of this syllabus always lives in this repository.

## Basic Course Information

- **Course title and number:** BIOL8001 Graduate Statistics
- **Term:** 2026 Fall
- **Modality:** In Person
- **Meeting day(s):** Tuesday, Thursday
- **Meeting time(s):** 9:30–10:50 AM
- **Meeting location:** SWIFT 516

## Instructor Information

- **Name:** Dieter Vanderelst
- **Instructor title:** Associate Professor
- **Instructor qualifications:**
  - MSc Theoretical and Experimental Psychology, Ghent University, 2005
  - MSc Artificial Intelligence (Cognitive Science), University of Leuven, 2006
  - PhD Biological Sciences, University of Antwerp, 2012

- **Office location:** Rieveschl Hall, Office 820G
- **Office hours:** Times vary; book a slot online at https://vanderdt-office-hours.appointlet.com/b/dieter
- **Office hours location:** Rieveschl Hall, Office 820G
- **Email:** vanderdt@ucmail.uc.edu
- **Webpage:** https://bitsofbats.notion.site/

## Course Overview

### Contents

Statistics is presented as a method for drawing inferences about the world from partial observations, specifically data. The course traces the logic of two major frameworks for inference: Bayesian reasoning and the Hypothesis Testing Framework, with an emphasis on their foundational intuitions. It addresses the complexities associated with Bayesian reasoning, the limitations of Hypothesis Testing, and implications of the latter for scientific research. Generative models are introduced as tools for drawing such inferences from data, with the linear model serving as the canonical example due to its simplicity, prevalence in the literature, unification of multiple techniques, and extensibility. The course employs R as a pedagogical tool to run simulations and demonstrate key concepts, as well as to implement the linear model and organize data.

### Format

Classes take place in person twice per week at the designated location and times. Each topic is developed using slides and live demonstrations in R. Students receive scripts to run alongside the demonstrations, rather than writing code from scratch. Several sessions are dedicated to in-class labs, where students run and modify provided simulations. Course materials are distributed as an RStudio project via the course repository. Students are required to bring a laptop with R and RStudio installed.

Each topic is followed by a set of exercises, some designed for written reasoning and others for implementation in R. Students complete these exercises independently and submit their answers. Exercises are then reviewed collectively in class, with additional time allocated to challenging concepts. Exercise sets are graded based on submission rather than correctness (see [Assessment/Activities and Grading Policy](#assessmentactivities-and-grading-policy)). The primary purpose of these exercises is to enable students to assess their understanding and to inform the instructor about areas requiring further clarification.

### Course Learning Outcomes

By the end of this course, students will be able to:

1. Describe a statistical model as a process that generates data, and identify its parameters, its mechanism, and the data it produces.
2. Choose a probability distribution to model a simple process, and justify that choice from the mechanism generating the data rather than from the shape of a histogram.
3. Simulate data in R from a specified process, and compare simulated data against observed data.
4. Explain what a sampling distribution is, distinguish it from the population and from a single sample, and use it to reason about the uncertainty of an estimate.
5. Interpret a Bayesian and a hypothesis-testing answer to the same question, and explain what each does and does not tell you.
6. Fit a linear model to data, interpret its coefficients, and assess whether an effect is supported by the data.
7. Report statistical results honestly, including the limitations of *p*-values and the uncertainty attached to an estimate.
8. Work within an RStudio project: read data from files, and read and run R scripts to reproduce an analysis.

### Assessment/Activities and Grading Policy

The final grade has two components:

| Component                  | Weight   |
| -------------------------- | -------- |
| Exercise sets (submission) | 10%      |
| Final exam                 | 90%      |

#### Exercise sets

Each topic is followed by a set of exercises: some call for reasoning on paper, others for running and interpreting code in R. A set is posted when its topic finishes and is due _[TBD — a deadline falling at least two days before the class in which it is reviewed]_.

Exercise sets are graded **on submission, not on correctness**. Credit is given for a genuine attempt at every question, and incorrect answers carry no penalty — those are, in fact, the useful ones.

This is deliberate. Submitted work shows the instructor which ideas landed and which did not, so that the session spent reviewing a set can be given over to the questions that proved difficult rather than to those everyone answered. Responsibility for making this work rests with the student: see [Artificial Intelligence Guidelines](#artificial-intelligence-guidelines).

#### Final exam

The exam is written **on paper, without AI tools or other aids** _[confirm what, if anything, is permitted — formula sheet, calculator]_.

It is designed to test whether students hold the framework of the course as a whole: why a particular model suits a particular process, what a result does and does not license, and how the pieces relate to one another. It is not a test of recall. Students are not asked to reproduce formulas from memory or to write R code from a blank page.

_[TBD — exam date and duration; make-up exam policy.]_

#### Grading scale

_[TBD — letter-grade cutoffs. UC's grading scales and definitions are linked under [Pass/Fail, Audit, and Withdrawal](#passfail-audit-and-withdrawal).]_

### Artificial Intelligence Guidelines

Artificial intelligence tools are now ubiquitous, and they are genuinely useful. This course aims to equip students with the cognitive and programming tools to apply, reason about, and critically assess statistics — whether in academic research, in industry, or anywhere else that draws inferences from data. AI is part of that toolkit.

Students are therefore allowed and encouraged to use AI assistants while working through the material and while completing exercise sets. No disclosure is required. Exercise sets are graded on whether a genuine attempt was submitted, never on whether the answers were correct, so nothing is gained by having an AI produce them — and something is lost. Submitted work is what determines which questions receive class time. Answers that are correct because a machine produced them, and that the student does not understand, secure a grade that was already assured and forfeit the explanation that was needed.

AI should be used as a tool, not as an authority. AI systems are fluent and confident about statistics, and confidently wrong often enough that their output has to be checked, and pushed back on when an answer does not match what is known about the process that produced the data. Being unable to distinguish a sound statistical answer from a plausible-sounding wrong one is precisely the weakness this course exists to remove. Using AI to get past a problem is also not the same as understanding it.

The exam is written on paper, without AI tools or other aids. See [Assessment/Activities and Grading Policy](#assessmentactivities-and-grading-policy) for what it covers and how it is designed.

## Required Course Materials

There is no required textbook for this course. All materials are freely available:

- Slide decks: The slides for this course can be found on Google Slides, https://tinyurl.com/BioGradStats
- R code: This repository hosts the R code for this course.
- R and Rstudio: These are free software tools that can be downloaded at no cost. For more information see:
  - https://en.wikipedia.org/wiki/R_(programming_language)
  - https://en.wikipedia.org/wiki/RStudio

While there is no required textbook, I can recommend the books by [Julian Faraway](https://julianfaraway.github.io) as **optional** resources to students. These books are freely available (electronically) through the UC library.

Students are not required to purchase additional resources for the course.

## Course Calendar

Below, the topics to be covered are listed, including the approximate number of class periods that will be devoted to each.

**No class on:** Tuesday November 3 (Reading Day) and Thursday November 26 (Thanksgiving). Labor Day, the October 12 Reading Day, and Veterans Day all fall on non-class days.

| Topic                                      | Topics                                                       | Number of class periods |
| ------------------------------------------ | ------------------------------------------------------------ | ----------------------- |
| Course Introduction & Theoretical Overview | We will briefly cover the theoretical arc of the course, i.e., Statistics as reasoning about a partly-observed states (parameters) of the world, which requires generating data for hypothetical parameters and comparing this observed data. We will introduce two ways to do that comparison: Bayesian reasoning and the Hypothesis Testing Framework. We will briefly introduce the linear model as the one (generative) model most of the course reduces to. Finally, we will introduce R as the computational and pedagogical tool for this course. | 1                       |
|                                            |                                                              |                         |
|                                            |                                                              |                         |

## Course Schedule

### Course Introduction & Theoretical Overview

*~1 class*

Statistics as reasoning about a partly-observed world (all conclusions are probabilistic); parameters as unobserved states of the world; the shape of the course — *make up the data a process would produce, compare it to the data we actually got, judge the parameters* ("statistics in three lines"); two ways to do that comparison — Bayesian reasoning vs the Hypothesis Testing Framework; the linear model as the one model most of the course reduces to.

Slide decks:
+ Course Outline — _Google Slides link TBD_

Code:
+ —

### Getting Started with R

*~2 classes + optional clinic*

The RStudio Project workflow; scripts, R Markdown, and running code; reading and inspecting data files (file/project management, tidyverse I/O); a first look at basic R code — vectors, `plot`/`hist`, loops — enough to **read and run** the scripts used later as demos, not to write them. Optional clinic: hands-on running scripts, loading data, and troubleshooting file paths.

Slide decks:
+ Getting Started With R — _Google Slides link TBD_
+ Overview of Basic R Code — _Google Slides link TBD_

Code:
+ [RunningScripts.Rmd](RunningScripts.Rmd) — the clinic
+ [CodeOverview.Rmd](CodeOverview.Rmd)

### Simulating Data & Distributions

*~1–2 classes*

Making up data we never collected: give R a process and its parameters, and it hands back the data that process would produce. Distributions as models of simple processes — the Binomial (counting successes), Poisson (counting rare events), and Geometric (waiting for the first success); the Normal as what you get when many small independent effects add up (central limit theorem). Throughout, the same move: simulate the process step by step, then reveal the distribution as its **closed-form shortcut** and overlay the two to see they match.

Slide decks:
+ Distributions — _Google Slides link TBD_

Code:
+ [Distributions.Rmd](Distributions.Rmd)

### Sampling Distributions

*~2 classes (includes an in-class lab)*

The same simulation as topic 3, one loop deeper: instead of making up *one* dataset, make up a thousand and compute a statistic from each. A statistic computed from a sample is itself random; keep the three distributions apart (population, one sample, the sampling distribution); simulate the sampling distribution of the mean; the closed-form shortcut Normal(μ, σ/√n) and the standard error; how spread shrinks with n (the √n law); every statistic has a sampling distribution (median, sd, proportion — foreshadowing t/χ²/F); from an estimate to an inference (seeds hypothesis testing and confidence intervals, built later). Lab: run and tweak a sampling-distribution simulator (ungraded, in class).

Slide decks:
+ Sampling Distributions — _Google Slides link TBD_

Code:
+ [SamplingDistributions.Rmd](SamplingDistributions.Rmd)
+ [SamplingDistributionsLab.Rmd](SamplingDistributionsLab.Rmd) — the lab

### Bayesian Reasoning

*~2 classes*

Bayes' theorem; reasoning backwards — we can simulate the data a parameter would produce (topic 3), so we can ask which parameter values would have produced *our* data. A model with an unknown parameter that generates data has a name: the **generative model**, the idea the rest of the course is built on. Worked from the simple case (a discrete cause, tallied by hand) up to a continuous world parameter (estimating a population mean, prior → likelihood → posterior → credible interval). Base-rate neglect: societal, medical, and justice impacts.

Slide decks:
+ Bayesian Reasoning — _Google Slides link TBD_

Code:
+ BayesianReasoning.Rmd — _planned_

## University Policies and Student Resources

### Class Cancellation Policy

In the rare case that a class must be cancelled, or that a faculty member is absent, faculty will post an announcement on Canvas or email information to students. Faculty will attempt to communicate class cancelations with as much advance notice as possible. Students should be sure that their LMS email is current and valid to ensure emails are received.

For information on class cancellation due to emergency procedures follow the link below: [Emergency Closing Procedure](https://www.uc.edu/content/dam/uc/trustees/docs/rules_10/10-55-01.pdf).

### Pass/Fail, Audit, and Withdrawal

- For information on Adding, Dropping, and Withdrawing from classes, please visit: [University of Cincinnati Office of Registrar](https://www.uc.edu/about/registrar/registration/policies/add-drop-withdrawal.html)
- For information on Grading Scales and Definitions, please visit: [University of Cincinnati Grading Scales and Definitions](https://www.uc.edu/about/registrar/transcripts-diplomas-verifications/grading-scales.html)

### Notice of Non-Discrimination

For the University of Cincinnati's Notice of Non-Discrimination, please visit: [UC Notice of Non-Discrimination](https://www.uc.edu/about/non-discrimination.html)

### Student Religious Accommodations

For information on the University's Religious Accommodations Policy, please visit: [Student Religious Accommodations Policy](https://www.uc.edu/content/dam/refresh/equityinclusion-62/oeo/UC%20Policy%201.3.7.pdf)

### Accessibility Policy

If you have a physical, psychological, or cognitive disability (learning, ADD/ADHD, psychological, visual, hearing, physical, cognitive, medical condition, etc.), UC's Accessibility Resources and your college's Access Coordinator are here to ensure you receive reasonable accommodations.

I encourage you to contact [Accessibility Resources](mailto:accessresources@uc.edu) to schedule a confidential meeting to discuss services and accommodations, or to begin by registering for accommodations. UC uses an online system called [UC Accommodate](https://uc-accommodate.symplicity.com/), where you'll be able to register and manage your accommodations (use your UC username and password for access).

Below are a few helpful UC Accommodate resources:

- [UC Accommodate Student Portal Overview](https://accessibilityresources.mediaspace.kaltura.com/media/UC+Accommodate+Student+Portal+Overview/1_0k0dohbj)
- [How to Schedule an Appointment in UC Accommodate](https://accessibilityresources.mediaspace.kaltura.com/media/How+to+Schedule+an+Appointment+in+UC+Accommodate/1_0xrq1pp6)
- [How to Submit a Semester Request in UC Accommodate](https://accessibilityresources.mediaspace.kaltura.com/media/How+to+Submit+a+Semester+Request+in+UC+Accommodate/1_qixw2iil)

### Academic Integrity

For information on the University's Academic Misconduct Policies: Academic Misconduct | University of Cincinnati _[link TBD — not hyperlinked in the printed template]_

### Learning Commons

The Learning Commons provides centralized academic support for all University of Cincinnati students by offering tutoring, coaching, writing support, and many additional programs that you can access via registered courses, appointments, or just dropping into the office. Learning Commons professionals and Peer Educators are available to help create flexible academic success programming whether you need some assistance with brainstorming ideas for your assignment, improving a draft, or managing your time. Check out the Learning Commons website to learn about available support and how to schedule appointments. You can also call the Learning Commons at 513-556-3244 or stop by the desk on the ground floor of French Hall West or Langsam Library at the Academic Writing Center (AWC).

### Title IX

For information on the University's Title IX Policy click the link: [Title IX Policy - Ethics, Compliance & Community Impact | University of Cincinnati](https://www.uc.edu/about/ethics-compliance-community/about/policies/title-ix.html)

### Help for Student Victims & Student Survivors

The [Help for Student Victims & Student Survivors](https://www.uc.edu/campus-life/safe.html) website provides resources for victims or survivors of sexual harassment, including sexual assault, dating or domestic violence, gender-based harassment, or stalking. Staff are available 24-hours a day for confidential advice and assistance.

### Mental Health Resources

Mental Health counseling and a variety of resources are available to UC students through [Counseling & Psychological Services (CAPS)](https://www.uc.edu/campus-life/caps.html). The Crisis, Assessment, Referral, Evaluation Team ("CARE Team") responds to reports about students whose behavior is raising concerns within the University community. More information about the CARE Team can be found in the University's [Mental Health Assessment Policy](https://www.uc.edu/content/dam/refresh/policies/414-Mental-Health-Assessment.pdf).

### Bearcats Pantry and Resource Center

The [Bearcats Pantry and Resource Center](https://www.uc.edu/bcp.html) is available to all UC students. From free food to social services support, they provide a range of programs, services, and supplies. Each student may visit once per week and receive up to 20lbs of goods per visit. You will need to make a [PantrySOFT account](http://app.pantrysoft.com/login/uc) and present your physical Bearcat Card for entry. They also encourage you to bring a reusable bag when you visit.

### UC Public Safety

The Department of Public Safety at the University of Cincinnati is committed to providing a safe campus environment for students, faculty, staff and visitors. Visit the [UC Public Safety website](https://www.uc.edu/about/publicsafety.html) to learn more about public safety and emergency response resources and services.
