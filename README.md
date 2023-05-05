# Public_Scripts
Scripts that are shareable/of possible use to other people

## upset_prep.R

__TODO__

- accept a config file set names, paths and parse information through script to produce figures with minimal input.
- add unit tests
- add ability to change output location
- add ability to execute at bash and pass flags


**INPUT:** currently outlines code acceptance for 3 differential expression tables in .txt format. Pending update to make more agnostic.

**OUTPUT:** Saves upset plot to Desktop location. Pending update to make easier to change. 

### USAGE

To use, edit the variables between lines 22-38. They are as follows: 

- de_paths: the full path to each of your differential expression tables
- de_setname: the set names that describe your tables. These set names will be used in the upset figure on the x axis
- sig_logFC: the log2fold change value you consider significant. The script will then evaluate each log2FC value as being up if greather than the positive of this number, down if less than the negative of this number, and flat or no change if between the negative and positive of this number.
- logfc_col: The column name where your log2fold change values reside
- transcript_col: The column name where your transcript names reside

The last two entries are so I can perform some transformations in the code with specific column names. 
