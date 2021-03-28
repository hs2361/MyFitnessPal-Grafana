ALTER USER postgres WITH PASSWORD 'admin';
create database myfitnesspal;
\c myfitnesspal;

create table if not exists meals
(
    date          date,
    day           varchar(10),
    meal_index    int,
    meal          varchar(10),
    food          varchar(255),
    calories      float,
    carbohydrates float,
    fat           float,
    protein       float,
    sodium        float,
    sugar         float
);