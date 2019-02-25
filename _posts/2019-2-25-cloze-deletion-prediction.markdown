---
layout: post
title:  "Cloze deletion prediction"
date:   2019-2-25 10:00:00 -0800
categories: dev
tags: [neural-network, machine-learning, project, python, NLP]
comments: true
---

A cloze deletion test is a form of language test where a sentence (or paragraph) is given to the test
taker with blanks for missing words. The student is expected to fill in a "correct" word in the
blanks. I compare the difference between an LSTM (Long-Short term memory) neural network with that
of a Bidirectional LSTM. Later the two news sources (described in Section 2) are compared to see
which data set is easier to predict. Then I explore tuning the dropout parameter to see how overfitting
can be improved. Finally the predictions are analyzed to see which sentences are easy to predict.

[Full project available here (PDF)](/resources/cloze_deletion_eng.pdf)
