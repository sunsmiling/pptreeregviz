

##### Test with CRAN version of shapr to identify expected behavior####

install.packages("shapr")
install.packages("PPtreeregViz")
library(shapr)
library(PPtreeregViz)


library(MASS)
data("Boston")

set.seed(1234)
proportion = 0.7
idx_train = sample(1:nrow(Boston), size = round(proportion * nrow(Boston)))
sample_train = Boston[idx_train, ]
sample_test =  Boston[-idx_train, ]
sample_one <- sample_test[sample(1:nrow(sample_test),1),-14]

Model <- PPtreeregViz::PPTreereg(medv ~., data = sample_train, DEPTH = 2)


shap_simple <- PPtreeregViz::ppshapr.simple(PPTreeregOBJ = Model, testObs = sample_one, final.rule = 5)$dt
shap_empirical <-PPtreeregViz::ppshapr.empirical(PPTreeregOBJ = Model, testObs = sample_one, final.rule = 5)$dt


saveRDS(list(shap_simple = shap_simple,
             shap_empirical = shap_empirical),
        file = "shapr_PPtreeregViz_cran_test.rds")


#### Modified script with GitHub development version ####

#library(shapr)
remotes::install_github("NorskRegnesentral/shapr")
remotes::install_github("martinju/PPtreeregViz")

library(MASS)
data("Boston")

set.seed(1234)
proportion = 0.7
idx_train = sample(1:nrow(Boston), size = round(proportion * nrow(Boston)))
sample_train = Boston[idx_train, ]
sample_test =  Boston[-idx_train, ]
sample_one <- sample_test[sample(1:nrow(sample_test),1),-14]

Model <- PPtreeregViz::PPTreereg(medv ~., data = sample_train, DEPTH = 2)


shap_simple <- PPtreeregViz::ppshapr.simple(PPTreeregOBJ = Model, testObs = sample_one, final.rule = 5)$dt
shap_empirical <-PPtreeregViz::ppshapr.empirical(PPTreeregOBJ = Model, testObs = sample_one, final.rule = 5)$dt


saveRDS(list(shap_simple = shap_simple,
             shap_empirical = shap_empirical),
        file = "shapr_PPtreeregViz_GH_test.rds")



#### Check whether the results are identical:

cran_test <- readRDS("shapr_PPtreeregViz_cran_test.rds")
gh_test <- readRDS("shapr_PPtreeregViz_GH_test.rds")

all.equal(cran_test,gh_test)
# TRUE

