I acknowledge the use of ChatGPT on the 5th November 2026 to write a Python code for plotting population png 
Chat history: 

Write a short Python 3 script that uses matplotlib to draw a line plot.

Input and output:
- The script is given two command-line arguments: sys.argv[1] is the path to a
  text file, and sys.argv[2] is the path where the plot should be saved as a PNG.
- The text file has one data point per line in the format year,population
  with no header, for example:
    2020,8110610
    2021,8097062
    2022,8182098
- Read every line, convert year and population to integers.

The plot:
- A line plot of population (y-axis) against year (x-axis), with a marker on
  each point.
- Title: "NSW estimated resident population"
- x-axis label "Year", y-axis label "Population".
- Save it to the path in sys.argv[2] as a PNG.

Requirements:
- It runs inside a Docker container with no display, so call
  matplotlib.use("Agg") before importing matplotlib.pyplot.
- Use only the standard library and matplotlib (no pandas or numpy).
- Don't print anything and don't call plt.show().
- Keep it simple and short, with no extra features.
import sys
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

years = []
populations = []

with open(sys.argv[1], "r") as file:
    for line in file:
        year, population = line.strip().split(",")
        years.append(int(year))
        populations.append(int(population))

plt.plot(years, populations, marker="o")
plt.title("NSW estimated resident population")
plt.xlabel("Year")
plt.ylabel("Population")
plt.savefig(sys.argv[2], format="png")
plt.close()

Run it inside Docker:

python3 plot.py data.txt population.png

Make sure matplotlib is installed in your container:

pip install matplotlib





