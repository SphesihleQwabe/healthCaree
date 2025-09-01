import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

def load_and_process_data(base_path):
    # Load all CSV files
    geography_provinces = pd.read_csv(base_path + "geography_provinces.csv")
    geography_districts = pd.read_csv(base_path + "geography_districts.csv")
    households = pd.read_csv(base_path + "households.csv")
    persons = pd.read_csv(base_path + "persons.csv")
    insurance_coverage = pd.read_csv(base_path + "insurance_coverage.csv")
    conditions_wide = pd.read_csv(base_path + "conditions_wide.csv")
    visits = pd.read_csv(base_path + "visits.csv")
    
    # Create target variable: Total Visits per Person
    visits_per_person = visits.groupby('person_id').size().reset_index(name='total_visits')
    
    # Merge with persons data
    main_df = pd.merge(visits_per_person, persons, on='person_id', how='right')
    main_df['total_visits'].fillna(0, inplace=True)
    main_df['total_visits'] = main_df['total_visits'].astype(int)
    
    # Merge with households data
    main_df = pd.merge(main_df, households, on='household_id', how='left')
    
    # Merge with insurance coverage
    main_df = pd.merge(main_df, insurance_coverage, on='person_id', how='left')
    
    # Merge with health conditions
    main_df = pd.merge(main_df, conditions_wide, on='person_id', how='left')
    
    # Merge with geographical districts
    main_df = pd.merge(main_df, geography_districts, on='district_id', how='left')
    
    # Data cleaning
    numeric_columns = main_df.select_dtypes(include=[np.number]).columns
    ids_and_target = ['person_id', 'household_id', 'district_id', 'total_visits']
    numeric_columns_to_clean = [col for col in numeric_columns if col not in ids_and_target]
    
    for column in numeric_columns_to_clean:
        main_df[column].fillna(main_df[column].median(), inplace=True)
    
    # Handle categorical variables
    categorical_columns = main_df.select_dtypes(include=['object']).columns
    label_encoder = LabelEncoder()
    
    for col in categorical_columns:
        main_df[col].fillna('Unknown', inplace=True)
        main_df[col] = label_encoder.fit_transform(main_df[col].astype(str))
    
    return main_df

def train_model(data):
    # Prepare features and target
    X = data.drop(['person_id', 'household_id', 'district_id', 'total_visits'], axis=1)
    y = data['total_visits']
    
    # Split the data
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Train the model
    model = RandomForestRegressor(n_estimators=100, random_state=42)
    model.fit(X_train, y_train)
    
    # Make predictions
    y_pred = model.predict(X_test)
    
    # Calculate metrics
    mae = mean_absolute_error(y_test, y_pred)
    mse = mean_squared_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)
    
    return model, X_train, X_test, y_train, y_test, y_pred, mae, mse, r2