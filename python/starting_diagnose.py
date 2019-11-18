#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Nov  8 13:43:16 2019

@author: niall
"""

# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import sys
from tkinter import *
from tkinter import messagebox

# Import the dataset
dataset = pd.read_csv('patient_data_py.csv', header=None)
# Get the question details
question_type = []
question = []
question_symptom =[]
for i in range(0, 28): # there are 28questions in total
    question_type.append(str(dataset.values[0, i]))
    question.append(str(dataset.values[1, i]))
    question_symptom.append(str(dataset.values[2, i]))
# Get the answers and the diagnoses (the model data)
X = dataset.values[3:, :28].astype('int') # the sample data for the model
age = dataset.values[3:, 28].astype('float').reshape(-1, 1)
y = dataset.values[3:, 31:34].astype('int') # the target data for the model
# convert the target data into the labels (the diagnoses)
y_cat = [];
for i in range(0, len(y)):
    if y[i, 0] == 1:
        y_cat.append('flexion')
    elif y[i, 1] == 1:
        y_cat.append('extension')
    elif y[i, 2] == 1:
        y_cat.append('mixed')
y_cat = np.array(y_cat)
            
## Train the model
# Fitting Naive Bayes to the yes/no answers
from sklearn.naive_bayes import BernoulliNB
classifier_bernoulli = BernoulliNB()
classifier_bernoulli.fit(X, y_cat)
prob_x_given_y_bernoulli = classifier_bernoulli.predict_proba(X) # can use this method to get P(X|Y)
features_bernoulli = classifier_bernoulli.classes_
prob_y_bernoulli = classifier_bernoulli.class_count_ / len(y_cat)
prob_y_given_x_bernoulli = prob_x_given_y_bernoulli * prob_y_bernoulli

## Predicting the Test set results
#y_pred_bernoulli = classifier_bernoulli.predict(X)
#
## Making the Confusion Matrix
#from sklearn.metrics import confusion_matrix
#cm_bernoulli = confusion_matrix(y_cat, y_pred_bernoulli)

# Fitting Naive Bayes to the yes/no answers
from sklearn.naive_bayes import GaussianNB
classifier_gauss = GaussianNB()
classifier_gauss.fit(age, y_cat)
prob_x_given_y_gauss = classifier_gauss.predict_proba(age) # can use this method to get P(X|Y)
features_gauss = classifier_gauss.classes_
prob_y_gauss = classifier_gauss.class_count_ / len(y_cat)
prob_y_given_x_gauss = prob_x_given_y_gauss * prob_y_gauss

## Predicting the Test set results
#y_pred_gauss = classifier_gauss.predict(age)
#
## Making the Confusion Matrix
#from sklearn.metrics import confusion_matrix
#cm_gauss = confusion_matrix(y_cat, y_pred_gauss)

## multiply the X|Y probabilities of the binary data and age data together to get a full model
#prob_x_given_y_full = prob_x_given_y_bernoulli * prob_x_given_y_gauss
#prob_y_given_x_full = prob_x_given_y_full * prob_y_gauss
#imax = np.argmax(prob_y_given_x_full, axis=1)
#y_pred_full = features_gauss[imax]

## Making the Confusion Matrix
#from sklearn.metrics import confusion_matrix
#cm_full = confusion_matrix(y_cat, y_pred_full)
#
# Some plots for checking things out
#plt.figure()
#plt.scatter(age, prob_x_given_y_gauss[:, 0], c='b')
#plt.scatter(age, prob_x_given_y_gauss[:, 1], c='r')
#plt.scatter(age, prob_x_given_y_gauss[:, 2], c='g')
#
#plt.figure()
#plt.hist(age[y_cat=='flexion'], color='r', alpha=0.6)
#plt.hist(age[y_cat=='extension'], color='b', alpha=0.6)
#plt.hist(age[y_cat=='mixed'], color='g', alpha=0.6)

# Divide the questions by type. You know the correct indices, but this is for practice
question_aggravate = [question[i] for i, x in enumerate(question_type) if x == 'aggravating']  # 1-13
question_alleviate = [question[i] for i, x in enumerate(question_type) if x == 'alleviating']  # 14-20
question_comparison = [question[i] for i, x in enumerate(question_type) if x == 'comparison']  # 21-27


## The GUIs!!
from checkbox_gui import AskNameAndAge, AskQuestions
proceed = 0
obj0 = AskNameAndAge('please enter your details')
if obj0.quit == 0:
    patient_first_name, patient_last_name, patient_age = obj0.states
    patient_age = np.array(patient_age, dtype='int').reshape(-1, 1)
    print(patient_age)
    gui_aggravate = AskQuestions('indicate occasions that aggravate your symptoms'.upper() , question_aggravate)
    if gui_aggravate.quit == 0:
        ans_aggravate = gui_aggravate.states
        gui_alleviate = AskQuestions('indicate occasions that alleviate your symptoms'.upper(), question_alleviate)
        if gui_alleviate.quit == 0:
            ans_alleviate = gui_alleviate.states
            go_again = 1 # initialise
#            destroy_window = 0 # initialise
            while go_again == 1:
                go_again = 0 #re-initialise
#                if destroy_window > 0:
#                    error_window.destroy()
                gui_comparison = AskQuestions('indicate statements that apply to your condition'.upper(), question_comparison)
                if gui_comparison.quit == 0:
                    ans_comparison = gui_comparison.states
                    # check the answers for contradictions
                    if ans_comparison[0] == 1 and ans_comparison[1] == 1:
                        go_again = 1
                    elif ans_comparison[2] == 1 and ans_comparison[3] == 1:
                        go_again = 1
                    elif ans_comparison[4] == 1 and ans_comparison[5] == 1:
                        go_again = 1
                    if go_again == 1:
                        error_window = Tk()
                        error_window.withdraw()
                        a = messagebox.showerror('Error', 'Your answers contain some contradictions. Please read carefully and answer again.')
                        print(a)
                        if a:
                            error_window.destroy()
                    proceed = 1
                else:
                    proceed = 0
                    break

if proceed == 1:
    patient_answers = np.array(ans_aggravate + ans_alleviate + ans_comparison).reshape(1, -1)
    #patient_answers = np.zeros(28).reshape(1, -1)
    #patient_age = [[28]]
    ## Calculate the probabilities of each outcome, considering the patient's answers
    prob_x_given_y_bernoulli = classifier_bernoulli.predict_proba(patient_answers)
    print(prob_x_given_y_bernoulli.shape)
    prob_x_given_y_gauss = classifier_gauss.predict_proba(patient_age)
    print(prob_x_given_y_gauss.shape)
    prob_x_given_y_full = prob_x_given_y_bernoulli * prob_x_given_y_gauss
    print(prob_x_given_y_full.shape)
    prob_y_given_x_full = prob_x_given_y_full * prob_y_gauss
    print(prob_y_given_x_full.shape)
    imax = np.argmax(prob_y_given_x_full, axis=1)
    y_pred_full = features_gauss[imax]
    
    ## Save the information to a file
    import os.path
    from datetime import datetime
    
    if not os.path.isdir('new_casefiles'):
        print('Creating a directory to store the new casefiles')
        os.mkdir('new_casefiles')
    savepath = 'new_casefiles/%s_%s_%s.txt' % (patient_last_name, patient_first_name, datetime.now().strftime("%Y_%m_%d_%H_%M_%S"))
    print('writing the patient data to %s' % savepath)
    with open(savepath, "w") as f:
        f.write('First Name: %s\n' % patient_first_name)
        f.write('Last Name: %s\n' % (patient_last_name))
        f.write('Age: %i\n' % (patient_age))
        f.write('AGGRAVATING SYMPTOMS:\n')
        for i in range(0, len(question_aggravate)):
            if ans_aggravate[i] == 1:
                f.write('%s\n' % question_aggravate[i])
        f.write('ALLEVIATING SYMPTOMS:\n')
        for i in range(0, len(question_alleviate)):
            if ans_alleviate[i] == 1:
                f.write('%s\n' % question_alleviate[i])
        f.write('COMPARISON SYMPTOMS:\n')
        for i in range(0, len(question_comparison)):
            if ans_comparison[i] == 1:
                f.write('%s\n' % question_comparison[i])
    
    out = 'Your answers indicate that you most likely have %s pattern back pain' % (str(y_pred_full[0]).upper())
    print(out)
    show_window = Tk()
    show_window.withdraw()
    b = messagebox.showinfo('RESULT', out)
    if b:
        show_window.destroy()
else:
    print('Session ended by user')
    sys.exit()