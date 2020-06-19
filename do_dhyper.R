#!/usr/bin/env Rscript

options(warn=-1)

# Read in the command line arguments
# read in the line number limit
# read in the input file with hypergeometric ratio test numbers
# read in the name of the output file to print out all of the results

args <- commandArgs(trailingOnly = TRUE)

line_limit <- as.numeric(args[1])
summary_input_file <- args[2]
output_file_totals <- args[3]

sayHello <- function()
{
	mydata = read.table(file = summary_input_file, sep = "\t", header=T)	
	result <- list()
	x = 1;	
	while(x < line_limit) 
	{
		temp = subset(mydata, mydata$line_count==x)
		# since alz list is always less than est list!!
		if (temp$no_gwas_hits < temp$no_in_ppi_family)
		{
			res <- sum(dhyper(temp$intersection:temp$no_gwas_hits, temp$no_in_ppi_family, (11049-temp$no_in_ppi_family), temp$no_gwas_hits))
		}
		else 
		{
			res <- sum(dhyper(temp$intersection:temp$no_in_ppi_family, temp$no_gwas_hits, (11049-temp$no_gwas_hits), temp$no_in_ppi_family))
		}	
		exp <- ((temp$no_gwas_hits/11049)*(temp$no_in_ppi_family/11049))*11049
                enrichment_factor = temp$intersection/exp
                new_res = paste(res, "\t", temp$study,"\t", temp$no_gwas_hits,"\t", temp$no_in_ppi_family,"\t",temp$intersection,"\t",round(enrichment_factor, digits=1), "\t", res)
		result[[x]] <- new_res
		x = x + 1;
	}
	
	check = do.call(rbind, result)
	write.table(check, file = output_file_totals, sep = "\t", row.names = F, quote = F)
}

sayHello()
