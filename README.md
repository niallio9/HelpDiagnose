# HelpDiagnose

HelpDiagnose is an interactive tool that helps doctors to diagnose patients with back pain. In collaboration with a medical doctor, a
specific set of questions were developed that enable prescribed treatments to be categorised into one of three main groups: flexion-biased
treatment, extension-biased treatment, and mixed-bias treatment.

The dataset for the model was created by extracting data from anonymised, text-based, patient records.


NOTE: This application should only be used by trained professionals. Self-diagnosis using this application is not recommended.


### Prerequisites and Running

Matlab: The GUI uses a package called 'inputsdlg.m', which is included in this repository.
One of three models can be chosen to make the prediction: 'Naive Bayes', 'Random Forest', and 'Old School'. 'Old School' uses hard limits
defined by a medical doctor.

The main script is called 'HelpDiagnose.m'

Python: The GUI uses the native GUI package called Tkinter, to create an object oriented user interface.
scikit-learn is used to train the Naive Bayes model.

The main script is called 'starting_diagnose.py'

### Output

In both versions of the application, the patient's answers to the questions, as well as the predicted diagnosis, are saved to a text file
with identifiable information.
