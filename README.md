# calculation-flank-ridge-gear-skiving

# MATLAB Scripts for Processing and Visualization of Data

This repository contains MATLAB scripts for processing, analyzing, and visualizing data extracted from `.txt` files. The main functionalities include data extraction, calculations, and plotting results in various formats. Below are detailed instructions for each script and their use cases.

---

## Table of Contents

1. [Requirements](#requirements)
2. [Scripts Overview](#scripts-overview)
3. [How to Use the Scripts](#how-to-use-the-scripts)
4. [Output](#output)
5. [Customization](#customization)

---

## Requirements

- **MATLAB R2020b** or later
- Toolboxes (if available):
  - *Statistics and Machine Learning Toolbox* (for `boxplot`, optional)

---

## Scripts Overview

### 1. Data Extraction and Calculation
This script reads `.txt` files, extracts specific data, and performs calculations. The results are saved in a MATLAB table.

#### Key Features:
- Reads multiple `.txt` files from a specified folder.
- Extracts numerical data for calculations.
- Computes the mean and standard deviation for each dataset.

### 2. Individual Plots
Creates individual plots for each unique `Versuch_Schneide`:
- X-Axis: Ring numbers (in ascending order).
- Y-Axis: Mean values (`Mittelwert`).

#### Key Features:
- Uses consistent color schemes to represent `Versuch_Schneide`.
- Displays legends to differentiate data.

### 3. Combined Plots
Combines data across multiple `Versuch_Schneide`:
- X-Axis: Ring numbers.
- Y-Axis: Mean values aggregated over all `Versuch_Schneide`.

#### Key Features:
- Visualizes aggregated data for comparison.
- Customizable legends and labels.

### 4. Boxplot Visualization
Creates boxplots to analyze data distribution:
- X-Axis: `Versuch_Schneide`.
- Y-Axis: Distribution of mean values (`Mittelwert`) for all rings.

#### Key Features:
- Displays quartiles, medians, and data spread.
- Alternative manual implementation if the `boxplot` function is unavailable.

---

## How to Use the Scripts

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/yourrepository.git

	2.	Set Up MATLAB Environment:
	•	Ensure MATLAB is installed.
	•	Add the scripts to the MATLAB path or navigate to the folder containing the scripts.
	3.	Run the Scripts:
	•	Open MATLAB.
	•	Run the desired script:

>> run('script_name.m')


	4.	Folder Selection:
	•	Upon execution, the script prompts you to select a folder containing .txt files.
	•	Ensure the files follow the naming convention prefix_ring_suffix.txt (e.g., 1L_R34_001.txt).
	5.	View Results:
	•	Tables are saved in the MATLAB workspace as variables.
	•	Plots are generated and displayed in separate figure windows.

Output

Table

The output table includes the following columns:
	•	Versuch_Schneide: The prefix of the file name.
	•	Ring: The ring identifier.
	•	Mittelwert: The calculated mean value.
	•	Standardabweichung: The standard deviation.

Plots
	1.	Individual Plots:
	•	Plots for each Versuch_Schneide.
	•	Data grouped by Ring.
	2.	Combined Plot:
	•	Aggregate mean values across all Versuch_Schneide for each Ring.
	3.	Boxplot:
	•	Distribution of mean values (Mittelwert) for each Versuch_Schneide.

Customization
	•	File Format:
	•	Modify the file reading function to accommodate alternative formats.
	•	Visualization:
	•	Change the color schemes, axis labels, or title in the plotting sections.
	•	Calculations:
	•	Adjust the computations to include additional metrics if needed.

Contact

For any issues or inquiries, feel free to contact the repository maintainer at [your-email@example.com].

License

This project is licensed under the MIT License. See the LICENSE file for details.
