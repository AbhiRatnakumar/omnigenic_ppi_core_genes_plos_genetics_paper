#!/usr/bin/env Rscript

options(warn=-1)


args <- commandArgs(trailingOnly = TRUE)

input_file <- args[1]
output_file <- args[2]


sayHello <- function()
{
	mydata = read.table(file = input_file, sep = "\t", header=T)	
	res = p.adjust(mydata$p_value, method = "BH", n = length(mydata$p_value))	
	check = paste(res, "\t", mydata$p_value, "\t", mydata$ppi_family)
	write.table(check, file = output_file, sep = "\t", row.names = F, quote = F)
}

sayHello()
