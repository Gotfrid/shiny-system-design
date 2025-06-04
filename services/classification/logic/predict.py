# Authors: The scikit-learn developers
# SPDX-License-Identifier: BSD-3-Clause

from sklearn import svm
from sklearn.model_selection import train_test_split


def predict(X: list[list[float]], y: list[str]) -> list[str]:
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.33, random_state=42
    )

    clf = svm.SVC(kernel="linear", C=1.0)
    model = clf.fit(X_train, y_train)

    return model.predict(X_test).tolist()
