## Vietnamese Car Price Prediction Project

Welcome to the Car Price Prediction Project! This project focuses on predicting car prices using machine learning algorithms. The project includes data preprocessing, feature engineering, model selection, and an interface for real-time price prediction.

![Car Price Prediction](https://github.com/ThaiAnNguyen/DataAnalystPortfolio/assets/155811703/020145d6-315b-4f81-b160-fcd6d3f14d11)


### Dataset

The dataset used for this project is sourced from [Kaggle](https://www.kaggle.com/datasets/nguynthanhlun/vietnamese-car-price). It contains comprehensive information about car listings, including various features such as make, model, year, mileage, fuel type, and price. The dataset is available as a CSV file named `car_detail_en.csv`.

Please note that the dataset is not included in this repository. In addition, the dataset may have been updated since the completion of this project. Please ensure you are using the most recent version of the dataset for accurate analysis and results.

### Libraries and Dependencies

To run the `Car Price Prediction.ipynb` notebook successfully, make sure you have the following libraries installed:

- numpy
- pandas
- scikit-learn
- category_encoders
- ipywidgets
- ipython

You can install these libraries using pip:

```
pip install numpy pandas scikit-learn category_encoders ipywidgets ipython
```

### Project Workflow

The `Car Price Prediction.ipynb` notebook contains the Python code for the Car Price Prediction project. Here's an overview of the workflow:

1. Data Preprocessing: The dataset is loaded, missing values are handled, and any necessary data cleaning and normalization are performed. Cleaned data `df_cleaned.csv`, also available in this repository, is then exported automatically. Please replace my file export path with your own.

2. Feature Engineering: Categorical features are encoded using target encoding to capture the relationship between the features and the target variable.

3. Model Selection: Three regression algorithms (Linear Regression, Gradient Boosting, and Random Forest) are tested using loss functions and cross-validation techniques. The model with the best performance, Random Forest, is selected for further analysis.

4. Interface for Real-Time Prediction: An interface is created using widgets and IPython to allow users to input real data and obtain price predictions based on the selected Random Forest model.

Users are advised to choose and fill in all the features to maximize the accuracy of the prediction results. Missing or incomplete feature inputs may lead to less accurate predictions.

### Contact Information

If you have any questions, feedback, or would like to connect regarding the Car Price Prediction Project, feel free to reach out to me. You can contact me at thaian201001@gmail.com or connect with me on [LinkedIn](https://www.linkedin.com/in/nguyenchonthaian/).

Thank you for exploring the Car Price Prediction Project! I hope you find the prediction interface and the insights from the machine learning models valuable in estimating Vietnamese car prices accurately.
