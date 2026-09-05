# BIOL8001: Syllabus

> [!NOTE]
>
> The instructor reserves the right to update this syllabus as class needs arise. Any changes to the schedule, syllabus, or policies will be communicated promptly. The most current version of the syllabus is maintained in this repository.

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

Statistics is presented as a method for drawing inferences about the world from partial observations (i.e., data). The course traces the logic of two major frameworks for inference: Bayesian reasoning and the Hypothesis Testing Framework, emphasizing their foundational intuitions. It addresses the complexities of Bayesian reasoning, the limitations of Hypothesis Testing, and the latter's implications for scientific research. Generative models are introduced as tools for drawing such inferences from data, with the linear model as the canonical example because of its simplicity, prevalence in the literature, unification of multiple techniques, and extensibility. The course uses R as a pedagogical tool to run simulations, demonstrate key concepts, implement the linear model, and organize data.

### Format

Classes take place in person twice a week. Each topic is developed using slides and live demonstrations in R. Students receive scripts to run alongside the demonstrations instead of writing code from scratch. Several sessions are dedicated to in-class labs where students run and modify provided simulations. Course materials are distributed as an RStudio project via the course repository. Students should bring a laptop with R and RStudio installed.

Each topic is followed by a set of exercises, some designed to test and sharpen reasoning about theory while others focus on R coding. Students complete these exercises independently and submit their answers. We review exercises collectively in class, with extra time for challenging concepts. Exercises are graded based on submission rather than correctness (see [Assessment/Activities and Grading Policy](#assessmentactivities-and-grading-policy)). The primary purpose is to help students assess their understanding and inform the instructor about areas needing clarification.

### Course Learning Outcomes

By the end of this course, students will be able to:

1. Describe a statistical model as a process that generates data, and identify its parameters, its mechanism, and the data it produces.
2. Choose a probability distribution to model a simple process, and justify that choice.
3. Simulate data in R from a specified process, and compare simulated data against observed data.
4. Explain what a sampling distribution is, distinguish it from the population and from a single sample, and use it to reason about the uncertainty of an estimate.
5. Interpret a Bayesian and a hypothesis-testing answer to the same question, and explain what each does and does not tell you.
6. Fit a linear model to data, interpret its coefficient, and draw data-supported conclusions.
7. Report statistical results honestly, including the limitations of *p*-values and the uncertainty attached to an estimate.
8. Work within an RStudio project: read data from files, and read and run R scripts to reproduce an analysis.

### Assessment/Activities and Grading Policy

The final grade has two components:

| Component                  | Weight   |
| -------------------------- | -------- |
| Exercise sets (submission) | 10%      |
| Final exam                 | 90%      |

#### Exercise sets

A set of exercises follows each topic: some focus on reasoning about concepts, others on running and interpreting code in R. A set is posted when its topic finishes and is due _[TBD — at least two days before the class in which it is reviewed]_.

Exercise sets are graded **on submission, not on correctness**. Credit is given for a genuine attempt at every question, and incorrect answers carry no penalty, as they are often the most useful. Submitted work shows the instructor which ideas landed and which did not. Responsibility for making this approach work rests with the student: see [Artificial Intelligence Guidelines](#artificial-intelligence-guidelines).

#### Final exam

The exam is written, on paper, without AI tools or a computer. Students might bring printed/written notes and resources on paper. The exam will be designed to test whether students understand the course framework as a whole: why a particular model suits a particular process, what a result does and does not license, and how the pieces relate to one another. It is not a test of recall. Students are not asked to reproduce formulas from memory or to write R code from a blank page.

#### Grading scale



### Artificial Intelligence Guidelines

Artificial intelligence is now ubiquitous and useful. This course aims to equip students with the cognitive and programming tools to apply, reason about, and critically assess statistics, whether in academic research, industry, or anywhere else that draws inferences from data. AI is now part of that toolkit.

Students are therefore allowed and encouraged (but not obliged) to use AI assistants while working through the material and while completing exercise sets. No disclosure is required. However, AI should be used as a tool, not as an authority. AI systems are fluent and confident about statistics or coding, and confidently wrong often enough that their output must be checked and challenged. Exercise sets are graded on whether a genuine attempt was submitted, not on whether the answers were correct, so students gain nothing by having an AI produce them without understanding or critically assessing the AI’s output. Answers that are correct because a machine produced them, and that the student does not understand, forfeit the explanation that was needed later in class.

The exam is written on paper, without AI tools or other aids. See [Assessment/Activities and Grading Policy](#assessmentactivities-and-grading-policy) for what it covers and how it is designed.

## Required Course Materials

This course has no required textbook. All materials are freely available:

- Slide decks: The slides for this course can be found on Google Slides, https://tinyurl.com/BioGradStats
- R code: This repository hosts the R code for this course.
- R and RStudio: These are free software tools that can be downloaded at no cost. For more information, see:
  - https://en.wikipedia.org/wiki/R_(programming_language)
  - https://en.wikipedia.org/wiki/RStudio

While there is no required textbook, I can recommend the books by [Julian Faraway](https://julianfaraway.github.io) as **optional** resources to students. These books are freely available (electronically) through the UC library.

Students are not required to purchase additional resources for the course.

## Course Calendar

Below are the topics to be covered, including the approximate number of class periods devoted to each.

**No class on:** Tuesday November 3 (Reading Day) and Thursday November 26 (Thanksgiving). Labor Day, the October 12 Reading Day, and Veterans Day all fall on non-class days.

|      | Section                                        | Topics                                                       | Number of class periods                                      |
| ---- | ---------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1    | Course Introduction & Theoretical Overview     | We will briefly cover the theoretical arc of the course, i.e., Statistics as reasoning about partly-observed states (parameters) of the world, which requires generating data for hypothetical parameters and comparing this to observed data. We will introduce two ways to do that comparison: Bayesian reasoning and the Hypothesis Testing Framework. We will briefly introduce the linear model as the one (generative) model most of the course reduces to. Finally, we will introduce R as the computational and pedagogical tool for this course. | 1                                                            |
| 2    | Getting started with R                         | Since we will be using R as a tool for demonstrations and teaching, it's necessary to be familiar with loading, editing, saving, and running R code. We will review the RStudio Project workflow and cover basic R code sufficient to read and run the scripts used later as demos, not to write them. This section will be followed by an R clinic to ensure all students are confident with R and RStudio before covering statistical theory. | 3: Two lecture and lab sessions, followed by an "R clinic".  |
| 3    | Simulating data                                | Statistical inference compares (often implicitly) simulated data, under hypothetical parameters, with the observed data. In this section, we will cover distributions as models of simple processes whose parameters can be varied. To demonstrate how these allow us to simulate data, we will cover the Binomial and Geometric distributions. Staying with the Binomial, we will take one set of throws and ask how probable that result is under several hypothetical values of *p*: some values make what we saw ordinary, others make it a surprise. This makes the opening sentence of this section concrete. Asking the reverse question — what the data say about *p* — is the business of sections 5 and 6. Finally, we will see the Normal distribution as a special distribution, derived from the Central Limit Theorem. | 3: Two lecture and lab sessions, followed by a session of in-class exercises. |
| 4    | Sampling distributions                         | In the previous section, we covered how distributions allow sampling (simulating) data for simple processes. Each sample is stochastic. The sampling distribution describes how sample descriptors (i.e., "statistics") vary across repeats. Here, we will see how sampling distributions describe the expected observations (statistics) for a given hypothetical parameter value in the world. We demonstrate this using the sampling distribution of the mean and standard deviation. | 3: Two lecture and lab sessions and a session of in-class exercises. |
| 5    | Bayesian Reasoning                             | Bayes' theorem is the fundamental method for updating beliefs about the world (its parameters) from data. We will see how the theorem applies to simple cases (reasoning about specific cases) before demonstrating how it lets us update beliefs about world parameters. We will cover how the prior can be contentious. We will also briefly cover how the Theorem can be applied in medicine, law, and social inferences to avoid base rate neglect. Throughout,, we will emphasize how the Theorem uses simulated data for hypothetical parameter values. | 3: Two lecture and lab sessions and a session of in-class exercises. |
| 6    | The Hypothesis Testing Framework               | The Hypothesis Testing Framework is the dominant approach to statistical inference. We will briefly cover the framework's historical emergence. Then we will cover how it differs from Bayesian Reasoning, in approach and goal. Next, we will show how varying the parameters of simple, intuitive models (white swans/black swans) lets us check which parameter values are compatible with the data. After this, we will use the t-test as a simple demonstration of how the Hypothesis Testing Framework uses the sampling distribution to ask how surprising the observed data would be if a hypothetical parameter value were true and calculate the p-value. Returning to the first part of this section, we will emphasize how this is the reverse of the Bayesian question: having refused a prior, the framework can deliver P(data given a parameter value) but not P(a parameter value given the data). | 2: Two lecture and lab sessions. Since we will perform many hypothesis tests when covering the linear model, this section is not followed by in-class exercises. |
| 7    | The limits of the hypothesis testing framework | Despite its dominance, the Hypothesis Testing Framework has a number of fundamental issues, especially when used as a method for rejecting a null hypothesis. We will examine the case that the p-value is a worse-than-useless outcome: the hypothesis being rejected (that a world parameter is exactly zero)5 is rarely tenable to begin with, so a significant result often says more about how much data was collected than about the world. We will also see how low power inflates published effect sizes and makes a significant result more likely to be false, and consider some consequences for science that can, at least partially, be attributed to an over-reliance on the p-value. | 1: One lecture                                               |
| 8    | The simple linear model and Hypothesis testing | The simple linear model will be introduced as a stochastic generative model with three unknowns: an offset, a scaling parameter, and the magnitude of the variation in y that the line does not account for. The model is the full equation, noise included, and we will run it forward — choosing values for the three and generating data sets — to show that it generates data in the same way the distributions of section 3 did, with the one addition that the data now depend on a variable. We will then run it backward: given data, the best parameter values are those that, on average, regenerate the observed data most closely. This is done in two moves, one for each part of the model — where the line goes, and how far the points stray from it — and we will note that the general problem is solved for us by least squares and, more generally, maximum likelihood. Turning to hypothesis testing, we ask whether other parameter values remain compatible with the data, and in particular whether a parameter could be zero in the world. Any data can in principle come from any parameter values, and adding a parameter always improves the fit, even an irrelevant one, so the question is how much better the fitted model regenerates the data and whether an improvement of that size would be surprising in a world where the parameter really is zero. We answer it as we always have—simulate from the hypothesized world, compute the improvement, repeat—which gives the sampling distribution of the F statistic, with the F distribution as its closed-form shortcut. Simulating a world in which there is nothing to find will also show how often such a world produces a significant result anyway. We will close by returning to the framework of the opening sections: we generate data from a model with given parameters and check whether a value derived from that data is compatible with what we observed. Given the limits of the hypothesis testing framework, parameter values, confidence intervals, and coefficient-level uncertainty are the most informative outputs of the linear model. | 4: Two lecture and lab sessions followed by two in-class exercise sessions. |
| 9    | Multiple regression and model comparison       | Building on the previous section, we will cover how the linear model can be extended to multiple parameters. This leads to the concept of model comparison, i.e., an extension of (or different way of looking at) hypothesis testing using the linear model. This leads to ANOVA and ANCOVA, allowing us to work with discrete parameters using the same framework. | 5: Three lecture and lab sessions followed by two in-class exercise sessions. |
| 10   | Data Wrangling in R                            | We will provide an overview of how R can be used to clean and prepare data for analysis. | 1–4 lecture and lab sessions, depending on the time available |

## University Policies and Student Resources

### Class Cancellation Policy

In the rare case that a class must be canceled, or that a faculty member is absent, faculty will post an announcement on Canvas or email information to students. Faculty will attempt to communicate class cancellations with as much advance notice as possible. Students should ensure their LMS email is current and valid to receive emails.

For information on class cancellation due to emergency procedures, follow the link below: [Emergency Closing Procedure](https://www.uc.edu/content/dam/uc/trustees/docs/rules_10/10-55-01.pdf).

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

The Learning Commons provides centralized academic support for all University of Cincinnati students by offering tutoring, coaching, writing support, and many additional programs that you can access via registered courses, appointments, or just dropping into the office. Learning Commons professionals and Peer Educators are available to help create flexible academic success programming, whether you need some assistance with brainstorming ideas for your assignment, improving a draft, or managing your time. Check out the Learning Commons website to learn about available support and how to schedule appointments. You can also call the Learning Commons at 513-556-3244 or stop by the desk on the ground floor of French Hall West or Langsam Library at the Academic Writing Center (AWC).

### Title IX

For information on the University's Title IX Policy, click the link: [Title IX Policy - Ethics, Compliance & Community Impact | University of Cincinnati](https://www.uc.edu/about/ethics-compliance-community/about/policies/title-ix.html)

### Help for Student Victims & Student Survivors

The [Help for Student Victims & Student Survivors](https://www.uc.edu/campus-life/safe.html) website provides resources for victims or survivors of sexual harassment, including sexual assault, dating or domestic violence, gender-based harassment, or stalking. Staff is available 24-hours a day for confidential advice and assistance.

### Mental Health Resources

Mental Health counseling and a variety of resources are available to UC students through [Counseling & Psychological Services (CAPS)](https://www.uc.edu/campus-life/caps.html). The Crisis, Assessment, Referral, Evaluation Team ("CARE Team") responds to reports about students whose behavior is raising concerns within the University community. More information about the CARE Team can be found in the University's [Mental Health Assessment Policy](https://www.uc.edu/content/dam/refresh/policies/414-Mental-Health-Assessment.pdf).

### Bearcats Pantry and Resource Center

The [Bearcats Pantry and Resource Center](https://www.uc.edu/bcp.html) is available to all UC students. From free food to social services support, they provide a range of programs, services, and supplies. Each student may visit once per week and receive up to 20lbs of goods per visit. You will need to make a [PantrySOFT account](http://app.pantrysoft.com/login/uc) and present your physical Bearcat Card for entry. They also encourage you to bring a reusable bag when you visit.

### UC Public Safety

The Department of Public Safety at the University of Cincinnati is committed to providing a safe campus environment for students, faculty, staff, and visitors. Visit the [UC Public Safety website](https://www.uc.edu/about/publicsafety.html) to learn more about public safety and emergency response resources and services.