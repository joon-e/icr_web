This tool allows you to calculate various intercoder reliability measures. 

Datasets need to be formatted with one variable (=column) indicating the coding unit (e.g., article) and one variable indicating the respective coder, and one variable each per coded variable to test.

![Sample dataset with one variable indicating the coding unit (in this case, `post_id`) and one variable indicating the coder (`coder_id`)](sample.png)

The following file formats are currently supported:

- `.csv`: Please use commas as the delimiter. The first line should contain the variable/column names.
- `.tsv`: Please use tabs as the delimiter. The first line should contain the variable/column names.
- `.xlsx` / `.xls`
- `.sav` (SPSS data files)

Unit and coder id variables should be either string or integer variables, whereas test variables can be either string, integer, or float (see below). 

The following intercoder reliability measures are currently available:

- Simple percent agreement.
- Holsti's coefficient (mean pairwise percent agreement).
- Krippendorff's Alpha (see [Krippendorff, 2011](http://repository.upenn.edu/asc_papers/43).
- Cohen's Kappa (only available for two coders; see [Cohen, 1960)](https://doi.org/10.1177/001316446002000104).
- Fleiss' Kappa (see [Fleiss, 1971](https://doi.org/10.1037/h0031619)).
- Brennan & Prediger's Kappa (see [Brennan & Prediger, 1981](https://doi.org/10.1177/001316448104100307); for more than two coders, [von Eye's (2006)](https://doi.org/10.1027/1016-9040.11.1.12) proposed extension to multiple coders is computed).

All test variables are assumed to be nominal. You can provide other variable levels in the 'variable levels' field by in the form of `variable_name = variable_level`, with multiple variables separated by commas. Available levels are 'nominal', 'ordinal', 'interval', and 'ratio'. 

Nominal test variables can be represented by either integer codes or string labels, whereas ordinal variables must be represented by integer codes, and interval/ratio variables must be numeric (integer or float).

Please note that currently only the computation of Krippendorff’s Kappa is influenced by the variable level.
