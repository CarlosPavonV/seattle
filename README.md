# seattle
SeATTLE (Sequence Alignment Transformation into a Table for Later Edition)

Authors: Emmanuel A. Pavón-Vázquez, Carlos J. Pavón-Vázquez

With genomic datasets becoming more common it's increasingly important to have tools that make formatting easy.

Data complexity reduction is often necessary for computational or analytical reasons, and the extraction of single nucleotide polymorphisms (SNPs) is one of the most widespread ways to accomplish so. A particularly useful tool serving this purpose is the R package Phrynomics (Leaché et al. 2015: https://doi.org/10.1093/sysbio/syv053; https://github.com/bbanbury/phrynomics). Most of the data uploaded by authors to online repositories consist of a concatenated matrix (including invariant sites) and a partition file specifying the location of each locus in the matrix. However, in order for Phrynomics to identify parts of the alignment as different loci, separators need to be added between the sequences of each locus.

SeATTLE makes this task easy. It takes two files as input: the concatenated alignment in PHYLIP format and a plain text partition file in RAxML format. The output is a table with n rows (where n is the number of taxa) and l+1 columns (where l is the number of loci). The first column contains the names of the taxa. This table can be read into R and easily processed with Phrynomics. Additionally, having each locus in a column facilitates further loci filtering.

Currenlty, SeATTLE only runs in Linux. Simply download the script and use as follows (IMPORTANT: the partition file NEEDS to be named part.txt):

sh SeATTLE.sh <input_sequences_file> part.txt

If that didn't work, try:

bash SeATTLE.sh <input_sequences_file> part.txt

Progress will be printed to screen. The file "output.phy" is the final table with loci separated by tabs. This file can be read into R as follows (*NOTE: In order for Phrynomics to work properly, all bases need to be uppercase):

table <- read.table("output.phy", header = FALSE)

row.names(table) <- table[,1]

table[,1] <- NULL

And then read into phrynomics as follows:

library(phrynomics)

data <- ReadSNP(table)

If you use SeATTLE please cite it as follows:

Pavón-Vázquez, E.A., & C.J. Pavón-Vázquez. 2019. SeATTLE: Sequence Alignment Transformation into a Table for Later Edition. Available at: https://github.com/CarlosPavonV/seattle
