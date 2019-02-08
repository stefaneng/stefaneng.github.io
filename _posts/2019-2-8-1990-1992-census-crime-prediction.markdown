---
layout: post
title:  "1990-1992 Census Crime Rate Prediction"
date:   2018-05-25 10:00:00 -0800
categories: dev
tags: [linear-regression, statistics, project, R]
comments: true
---

In this project I look at a dataset that provides some demographic information for 440 of the most populous counties in the United States in years 1990-92. The crime rate for each of the countries is predicted using linear regression and then using negative binomial regression and the results are compared.

  - [Github page for this project](https://github.com/stefaneng/Census-Crime-Rate-Prediction)

  - [Read the full PDF report here](https://github.com/stefaneng/Census-Crime-Rate-Prediction/blob/master/1990-1992_census_crime_modeling.pdf)

## Introduction

In this analysis, I investigate a dataset that provides some demographic information for 440 of the most populous counties in the United States in years 1990-92. Each line of the dataset provides information on 14 variables for a single county. Counties with missing data Ire deleted from the dataset. I built models to predict the number of crimes per 1000 people in each county. I first explore linear regression models and then a negative binomial regression model. I found that the best linear regression model performed similarly to the negative binomial regression model on the training and test set using the same variables.

## Goals

  The goals of the analysis was the find a model that is simple yet explains as much as possible. The model should make sense first and foremost. Automatic methods such as the backwards step algorithm were used as auxiliary methods to supplement a more hand selected model. I decided against using all possible subsets selection as a matter of principle as it can lead to models that lack explainability. I explore interactions between variables as well as standard additive models. Once model selection is done based on the training set the final results are reported against the test set (20% of the dataset). The test set was not looked at or used in the model building process. The models were compared on the training set using 10-fold cross validation and leave one out cross validation (LOOCV).

## References
  - Project description at Chalmers: http://www.math.chalmers.se/Stat/Grundutb/GU/MSG500/A18/project18.pdf
