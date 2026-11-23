Differences between Groups
================

- [The R You Need](#the-r-you-need)
- [The Data](#the-data)
- [1. Tell R the Variable Is Categorical](#1-tell-r-the-variable-is-categorical)
- [2. Different Codings, Same Model](#2-different-codings-same-model)
- [3. Extra: Two Factors and Their Interaction](#3-extra-two-factors-and-their-interaction)
- [References](#references)

## The R You Need

A grouping variable goes into `lm()` like any other predictor. R turns it into 0/1 codes for you, as long as it knows the variable is categorical.

- **`factor()`:** tells R that a variable is categorical. Its first level is the reference group.
- **`lm(y ~ group)`:** with a factor as predictor, this is a one-way ANOVA. The `F-statistic` on the last line of `summary()` tests whether all group means are the same.
- **`contrasts = list(group = "contr.helmert")`:** an extra argument to `lm()` that changes how the groups are coded.

A minimal example, with the data used below:

``` r
penguins <- read.csv("data/penguins_coded.csv")
penguins$species <- factor(penguins$species)    # species is coded 1, 2, 3: without factor(), R sees numbers
fit <- lm(body_mass_g ~ species, data = penguins)
summary(fit)
```

## The Data

The Palmer penguins: Adélie, Chinstrap, and Gentoo penguins measured near Palmer Station, Antarctica, from 2007 to 2009 (Gorman et al., 2014). We use body mass (g) and species. The file holds the 333 penguins with both body mass and sex recorded, so every example in this section uses the same penguins.

Groups are often recorded as numbers, and these data are: species is a code, as it might be on a field sheet. The key that came with the data says 1 = Adélie, 2 = Chinstrap, 3 = Gentoo.

``` r
penguins <- read.csv("data/penguins_coded.csv")

head(penguins[, c("species", "body_mass_g")])
#>   species body_mass_g
#> 1       1        3750
#> 2       1        3800
#> 3       1        3250
#> 4       1        3450
#> 5       1        3650
#> 6       1        3625
table(penguins$species)
#> 
#>   1   2   3 
#> 146  68 119
```

## 1. Tell R the Variable Is Categorical

`str()` shows how R stores each column:

``` r
str(penguins)
#> 'data.frame':    333 obs. of  8 variables:
#>  $ species          : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ island           : chr  "Torgersen" "Torgersen" "Torgersen" "Torgersen" ...
#>  $ bill_length_mm   : num  39.1 39.5 40.3 36.7 39.3 38.9 39.2 41.1 38.6 34.6 ...
#>  $ bill_depth_mm    : num  18.7 17.4 18 19.3 20.6 17.8 19.6 17.6 21.2 21.1 ...
#>  $ flipper_length_mm: int  181 186 195 193 190 181 195 182 191 198 ...
#>  $ body_mass_g      : int  3750 3800 3250 3450 3650 3625 4675 3200 3800 4400 ...
#>  $ sex              : chr  "male" "female" "female" "female" ...
#>  $ year             : int  2007 2007 2007 2007 2007 2007 2007 2007 2007 2007 ...
```

The column `species` holds integers (`int`). So R treats it as a continuous predictor, like height in the linear-model section, and fits one slope:

$$\mathrm{mass}_i = \beta_0 + \beta_1 \times \mathrm{species}_i + \epsilon_i, \qquad \epsilon_i \sim N(0, \sigma^2), \qquad \mathrm{species}_i \in \{1, 2, 3\}$$

``` r
fit_numeric <- lm(body_mass_g ~ species, data = penguins)
summary(fit_numeric)
#> 
#> Call:
#> lm(formula = body_mass_g ~ species, data = penguins)
#> 
#> Residuals:
#>      Min       1Q   Median       3Q      Max 
#> -1562.12  -382.96   -32.96   367.04  1358.72 
#> 
#> Coefficients:
#>             Estimate Std. Error t value Pr(>|t|)    
#> (Intercept)  2903.80      69.52   41.77   <2e-16 ***
#> species       679.16      32.88   20.66   <2e-16 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Residual standard error: 533 on 331 degrees of freedom
#> Multiple R-squared:  0.5632, Adjusted R-squared:  0.5618 
#> F-statistic: 426.7 on 1 and 331 DF,  p-value: < 2.2e-16
```

This model has no error message, a tiny $p$-value, and is wrong. One slope means that each step from code 1 to 2, and from 2 to 3, adds the same mass: 679 g. The species means do not follow that pattern:

``` r
predicted <- predict(fit_numeric, newdata = data.frame(species = 1:3))
observed <- tapply(penguins$body_mass_g, penguins$species, mean)
round(cbind(predicted, observed))
#>   predicted observed
#> 1      3583     3706
#> 2      4262     3733
#> 3      4941     5092
```

With `factor()`, R treats the codes as groups and turns them into dummy codes: $x_1 = 1$ for Chinstrap (code 2) and $x_2 = 1$ for Gentoo (code 3). Adélie (code 1), the first level, gets $x_1 = x_2 = 0$:

$$\mathrm{mass}_i = \beta_0 + \beta_1 x_{1i} + \beta_2 x_{2i} + \epsilon_i, \qquad \epsilon_i \sim N(0, \sigma^2)$$

Put each species into both equations to see what mean each model gives it. The symbols are shared but the numbers are not: $\beta_1$ is the step per code in the numeric model, and the Chinstrap–Adélie difference in the factor model.

| Species   | Code | Numeric model        | Factor model        |
|-----------|:----:|----------------------|---------------------|
| Adélie    |  1   | $\beta_0 + \beta_1$  | $\beta_0$           |
| Chinstrap |  2   | $\beta_0 + 2\beta_1$ | $\beta_0 + \beta_1$ |
| Gentoo    |  3   | $\beta_0 + 3\beta_1$ | $\beta_0 + \beta_2$ |

The numeric model has two coefficients for three means, so the means must be equally spaced. The factor model has a coefficient for each species, so each species gets its own mean:

``` r
fit_factor <- lm(body_mass_g ~ factor(species), data = penguins)
summary(fit_factor)
#> 
#> Call:
#> lm(formula = body_mass_g ~ factor(species), data = penguins)
#> 
#> Residuals:
#>      Min       1Q   Median       3Q      Max 
#> -1142.44  -342.44   -33.09   307.56  1207.56 
#> 
#> Coefficients:
#>                  Estimate Std. Error t value Pr(>|t|)    
#> (Intercept)       3706.16      38.14  97.184   <2e-16 ***
#> factor(species)2    26.92      67.65   0.398    0.691    
#> factor(species)3  1386.27      56.91  24.359   <2e-16 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Residual standard error: 460.8 on 330 degrees of freedom
#> Multiple R-squared:  0.6745, Adjusted R-squared:  0.6725 
#> F-statistic: 341.9 on 2 and 330 DF,  p-value: < 2.2e-16
```

Does `factor()` really make R treat the codes as groups? Compare with a model that uses the species names. R knows that text is categorical, so names need no `factor()`. Make a column of names with the key:

``` r
key <- c("Adelie", "Chinstrap", "Gentoo")
penguins$species_name <- key[penguins$species]    # code 1 gets the first name, code 2 the second, code 3 the third
table(penguins$species, penguins$species_name)
#>    
#>     Adelie Chinstrap Gentoo
#>   1    146         0      0
#>   2      0        68      0
#>   3      0         0    119
```

The two fits have the same coefficients. Only their names differ:

``` r
fit_name <- lm(body_mass_g ~ species_name, data = penguins)
coef(fit_factor)
#>      (Intercept) factor(species)2 factor(species)3 
#>       3706.16438         26.92385       1386.27259
coef(fit_name)
#>           (Intercept) species_nameChinstrap    species_nameGentoo 
#>            3706.16438              26.92385            1386.27259
```

The numeric model also depends on an arbitrary choice: the order of the codes. Give Gentoo code 2 and Chinstrap code 3, and the numeric model fits differently. The factor model does not change:

``` r
new_codes <- c(1, 3, 2)    # Adelie stays 1, Chinstrap 2 becomes 3, Gentoo 3 becomes 2
penguins$species2 <- new_codes[penguins$species]

r2 <- function(model) summary(model)$r.squared
c(numeric_order1 = r2(fit_numeric), numeric_order2 = r2(lm(body_mass_g ~ species2, data = penguins)))
#> numeric_order1 numeric_order2 
#>     0.56315056     0.03970423
c(factor_order1 = r2(fit_factor), factor_order2 = r2(lm(body_mass_g ~ factor(species2), data = penguins)))
#> factor_order1 factor_order2 
#>     0.6744887     0.6744887
```

> [!WARNING]
> If a categorical variable is stored as numbers, `lm()` will not warn you. Check with `str()` and use `factor()`.

## 2. Different Codings, Same Model

From here on we use the species names. We replace the codes in `species` with the names, as a factor, so that R’s output says which species each coefficient is about:

``` r
penguins$species <- factor(penguins$species_name)    # levels in alphabetical order: Adelie is the reference
fit <- lm(body_mass_g ~ species, data = penguins)
```

Dummy coding is one way to turn groups into numbers. Helmert coding is another. The codes each species gets:

``` r
contr.treatment(levels(penguins$species))
#>           Chinstrap Gentoo
#> Adelie            0      0
#> Chinstrap         1      0
#> Gentoo            0      1
contr.helmert(levels(penguins$species))
#>           [,1] [,2]
#> Adelie      -1   -1
#> Chinstrap    1   -1
#> Gentoo       0    2
```

Both codings go into the same equation:

$$\mathrm{mass}_i = \beta_0 + \beta_1 x_{1i} + \beta_2 x_{2i} + \epsilon_i$$

Only the values of $x_1$ and $x_2$ differ: they are the rows of the tables above. Fit the model with Helmert coding, and the coefficients change:

``` r
fit_helmert <- lm(body_mass_g ~ species, data = penguins, contrasts = list(species = "contr.helmert"))
both <- rbind(dummy = coef(fit), helmert = coef(fit_helmert))
colnames(both) <- c("beta0", "beta1", "beta2")    # the column names R gives belong to one coding only
both
#>            beta0    beta1     beta2
#> dummy   3706.164 26.92385 1386.2726
#> helmert 4177.230 13.46193  457.6036
```

The model does not change. Both fits give every penguin the same fitted value, its species mean, so the residuals, $R^2$, and the $F$-test are the same:

``` r
all.equal(fitted(fit), fitted(fit_helmert))
#> [1] TRUE
rbind(dummy = summary(fit)$fstatistic, helmert = summary(fit_helmert)$fstatistic)
#>            value numdf dendf
#> dummy   341.8949     2   330
#> helmert 341.8949     2   330
c(dummy = r2(fit), helmert = r2(fit_helmert))
#>     dummy   helmert 
#> 0.6744887 0.6744887
```

What changes is the question each coefficient answers. To find out, put each species’ codes into the equation. This gives the mean of each species in terms of the $\beta$’s:

| Species   | Dummy coding        | Helmert coding                |
|-----------|---------------------|-------------------------------|
| Adélie    | $\beta_0$           | $\beta_0 - \beta_1 - \beta_2$ |
| Chinstrap | $\beta_0 + \beta_1$ | $\beta_0 + \beta_1 - \beta_2$ |
| Gentoo    | $\beta_0 + \beta_2$ | $\beta_0 + 2\beta_2$          |

With dummy coding, the $\beta$’s can be read off: $\beta_1$ is Chinstrap minus Adélie. With Helmert coding, solve the three equations for the three $\beta$’s:

$$\beta_0 = \tfrac{1}{3}(\bar{y}_A + \bar{y}_C + \bar{y}_G), \qquad \beta_1 = \tfrac{1}{2}(\bar{y}_C - \bar{y}_A), \qquad \beta_2 = \tfrac{1}{3}\left(\bar{y}_G - \tfrac{\bar{y}_A + \bar{y}_C}{2}\right)$$

Check with the species means:

``` r
m <- tapply(penguins$body_mass_g, penguins$species, mean)
by_hand <- c(beta0 = mean(m), beta1 = (m[["Chinstrap"]] - m[["Adelie"]]) / 2, beta2 = (m[["Gentoo"]] - (m[["Adelie"]] + m[["Chinstrap"]]) / 2) / 3)
rbind(by_hand, lm = coef(fit_helmert))
#>           beta0    beta1    beta2
#> by_hand 4177.23 13.46193 457.6036
#> lm      4177.23 13.46193 457.6036
```

Helmert’s $\beta_1$ is half of the dummy coding’s $\beta_1$. Both are 0 exactly when Adélie and Chinstrap have the same mean: the same question, scaled. So their $t$-tests agree:

``` r
summary(fit)$coefficients["speciesChinstrap", ]
#>   Estimate Std. Error    t value   Pr(>|t|) 
#> 26.9238517 67.6524263  0.3979732  0.6909073
summary(fit_helmert)$coefficients["species1", ]
#>   Estimate Std. Error    t value   Pr(>|t|) 
#> 13.4619259 33.8262132  0.3979732  0.6909073
```

## 3. Extra: Two Factors and Their Interaction

Body mass depends on species, and also on sex. Both are factors, and both go into the model. There are two ways to combine them.

The mean of each species × sex group, and the male–female gap in each species:

``` r
penguins$sex <- factor(penguins$sex)    # female is the reference: first in the alphabet
cell_means <- tapply(penguins$body_mass_g, list(penguins$species, penguins$sex), mean)
round(cell_means)
#>           female male
#> Adelie      3369 4043
#> Chinstrap   3527 3939
#> Gentoo      4680 5485
round(cell_means[, "male"] - cell_means[, "female"])
#>    Adelie Chinstrap    Gentoo 
#>       675       412       805
```

**The additive model** adds one more code, $x_3 = 1$ for males. Males are heavier by $\beta_3$, the same amount in every species:

$$\mathrm{mass}_i = \beta_0 + \beta_1 x_{1i} + \beta_2 x_{2i} + \beta_3 x_{3i} + \epsilon_i$$

``` r
fit_add <- lm(body_mass_g ~ species + sex, data = penguins)
summary(fit_add)
#> 
#> Call:
#> lm(formula = body_mass_g ~ species + sex, data = penguins)
#> 
#> Residuals:
#>     Min      1Q  Median      3Q     Max 
#> -816.87 -217.80  -16.87  227.61  882.20 
#> 
#> Coefficients:
#>                  Estimate Std. Error t value Pr(>|t|)    
#> (Intercept)       3372.39      31.43 107.308   <2e-16 ***
#> speciesChinstrap    26.92      46.48   0.579    0.563    
#> speciesGentoo     1377.86      39.10  35.236   <2e-16 ***
#> sexmale            667.56      34.70  19.236   <2e-16 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Residual standard error: 316.6 on 329 degrees of freedom
#> Multiple R-squared:  0.8468, Adjusted R-squared:  0.8454 
#> F-statistic: 606.1 on 3 and 329 DF,  p-value: < 2.2e-16
```

**The interaction model** also lets the gap differ between species. It adds the products of the species codes and the sex code. A product is 1 only for males of that species:

$$\mathrm{mass}_i = \beta_0 + \beta_1 x_{1i} + \beta_2 x_{2i} + \beta_3 x_{3i} + \beta_4 x_{1i} x_{3i} + \beta_5 x_{2i} x_{3i} + \epsilon_i$$

In R, `species * sex` is short for `species + sex + species:sex`, and `species:sex` is the interaction:

``` r
fit_int <- lm(body_mass_g ~ species * sex, data = penguins)
summary(fit_int)
#> 
#> Call:
#> lm(formula = body_mass_g ~ species * sex, data = penguins)
#> 
#> Residuals:
#>     Min      1Q  Median      3Q     Max 
#> -827.21 -213.97   11.03  206.51  861.03 
#> 
#> Coefficients:
#>                          Estimate Std. Error t value Pr(>|t|)    
#> (Intercept)               3368.84      36.21  93.030  < 2e-16 ***
#> speciesChinstrap           158.37      64.24   2.465  0.01420 *  
#> speciesGentoo             1310.91      54.42  24.088  < 2e-16 ***
#> sexmale                    674.66      51.21  13.174  < 2e-16 ***
#> speciesChinstrap:sexmale  -262.89      90.85  -2.894  0.00406 ** 
#> speciesGentoo:sexmale      130.44      76.44   1.706  0.08886 .  
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Residual standard error: 309.4 on 327 degrees of freedom
#> Multiple R-squared:  0.8546, Adjusted R-squared:  0.8524 
#> F-statistic: 384.3 on 5 and 327 DF,  p-value: < 2.2e-16
```

> [!WARNING]
> With an interaction in the model, the other coefficients change meaning. `sexmale` is no longer “the effect of sex”: it is the male–female gap in the reference species, Adélie, only. Likewise, `speciesChinstrap` is the Chinstrap–Adélie difference among females only. Solve the equations to see what each coefficient means.

Solving the equations: the gap is $\beta_3$ in Adélie, $\beta_3 + \beta_4$ in Chinstrap, and $\beta_3 + \beta_5$ in Gentoo. These are the gaps in the table of cell means:

``` r
b <- coef(fit_int)
c(Adelie = b[["sexmale"]], Chinstrap = b[["sexmale"]] + b[["speciesChinstrap:sexmale"]], Gentoo = b[["sexmale"]] + b[["speciesGentoo:sexmale"]])
#>    Adelie Chinstrap    Gentoo 
#>  674.6575  411.7647  805.0947
```

Do the gaps really differ between species, or is one gap enough? The additive model is the interaction model with $\beta_4 = \beta_5 = 0$, so the two models are nested and the $F$-test from the significance-testing section compares them:

``` r
anova(fit_add, fit_int)
#> Analysis of Variance Table
#> 
#> Model 1: body_mass_g ~ species + sex
#> Model 2: body_mass_g ~ species * sex
#>   Res.Df      RSS Df Sum of Sq     F    Pr(>F)    
#> 1    329 32979185                                 
#> 2    327 31302628  2   1676557 8.757 0.0001973 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The gaps differ: $p$ = 0.0002. But compare how much each step improves the fit:

``` r
c(species = r2(fit), species_sex = r2(fit_add), interaction = r2(fit_int))
#>     species species_sex interaction 
#>   0.6744887   0.8467935   0.8545820
```

Sex adds a lot to species. The interaction adds little, even though its $p$-value is tiny.

## References

Gorman, K. B., Williams, T. D., & Fraser, W. R. (2014). Ecological sexual dimorphism and environmental variability within a community of Antarctic penguins (genus *Pygoscelis*). *PLoS ONE*, 9(3), e90081.

Horst, A. M., Hill, A. P., & Gorman, K. B. (2020). *palmerpenguins: Palmer Archipelago (Antarctica) penguin data*. R package.
