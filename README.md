# tinymeta
A basic wrapper to simplify functions from the meta and netmeta packages. Designed for HUKSG use only.

# Installation
First, install devtools:
```
install.packages("devtools")
```
Then, install the package using the following code in your R console:
```
library(devtools)
install_github("QuietResearcher/tidymeta")
```

# Functions & Parameters
**simpleNMA.bin: Generates a netmeta NMA object for dichotomous outcomes.**
```
simpleNMA.bin (data, n, r, measure, correction, random, ref, sm.val)
```
Parameters:
data: Dataframe containing the following columns: study (study ID) and treatment (arm names)
      Optionally, the dataframe can also contain these columns: sampleSize and responders.
      *Dataframe should be in long/one-arm-per-row format* Seek guidence from HUKSG consulting researchers.

n: String of the column name containing sample size information. *Not needed if data contains sampleSize.*

r: String of the column name containing responders information. *Not needed if data contains responders.*

measure: String of summary measure (OR/RR). Default is OR. (optional parameter)

correction: Boolean of whether continuity correction should be used (TRUE/FALSE). Default is FALSE. (optional parameter)

random: Boolean of whether a random effects model should be used (TRUE/FALSE). Default is TRUE. (optional parameter)

ref: String name of the reference group. Default is "Untreated". (optional parameter)

sm.val: String indicating whether small effects are "good" or "bad" (for P-score ranking). Default is "good". (optional parameter)

Example:
```
results.bin <- simpleNMA.bin (data = data, measure = "OR", correction = TRUE, ref = "SOC")
```


