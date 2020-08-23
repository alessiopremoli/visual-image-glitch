import pandas as pd

# annual-co2-emissions-per-country
data = pd.read_csv('data.csv')
data.head

subsetData = data[['Year', 'Code', 'Annual CO₂ emissions (tonnes)']]
subsetData = subsetData[subsetData['Code'] == 'OWID_WRL']
subsetData = subsetData[subsetData['Year'] >= 1945]

forecast = [
    [2020, 'OWID_WRL', 35339.7578],
    [2025, 'OWID_WRL', 35704.5265],
    [2030, 'OWID_WRL', 36405.4302],
    [2035, 'OWID_WRL', 37457.1284],
    [2040, 'OWID_WRL', 38815.1894],
    [2045, 'OWID_WRL', 40781.9466],
    [2050, 'OWID_WRL', 43084.9515],
]

for element in forecast:
    element[2] = element[2] * 1000000

forecastData = pd.DataFrame(
    forecast,
    columns=['Year', 'Code', 'Annual CO₂ emissions (tonnes)']
)

subsetData = subsetData.append(forecastData, ignore_index=True)

print(subsetData)


subsetData[['Year', 'Annual CO₂ emissions (tonnes)']].to_csv('../filtered_data.csv', index = False, header=False)