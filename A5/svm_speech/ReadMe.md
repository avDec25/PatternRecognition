### Prerequisites
execute this command in an untouched libsvm folder:
make

now copy, 2 files:
to_train_svm
to_test_svm
in libsvm folder and within libsvm/tools folder; Both places.

### Test to check if training and testing data are in proper format
when in tools folder execute the following commands:
python checkdata.py to_train_svm
python checkdata.py to_test_svm

### Training
when in libsvm folder, execute the following commands:
./svm-train -h 0 to_train_svm
./svm-predict -b 0 to_test_svm  to_train_svm.model output

### Result
Classification Accuracy = 83.6015%
