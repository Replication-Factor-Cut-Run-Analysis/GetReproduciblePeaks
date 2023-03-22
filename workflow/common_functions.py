
def Tx_BamFiles_dict_from_samples(sample, samples_table):
    """
    Returns a space-separated string of treatment BAM files for a given sample from a samples table.

    Parameters:
    sample (str): Name of the sample.
    samples_table (pandas.DataFrame): Table containing information about the samples.

    Returns:
    str: Space-separated string of treatment BAM file names for the sample.
    """
    # Get a set of treatment BAM file names for the sample from the samples table
    bam_lst = set(samples_table.loc[samples_table["sample"] == str(sample), "treatmentBam"].to_list())

    # Join the list of BAM file names with a space separator and return the resulting string
    return ' '.join([str(item) for item in bam_lst])


def In_BamFiles_dict_from_samples(sample, samples_table):
    """
    Returns a space-separated string of input BAM files for a given sample from a samples table.

    Parameters:
    sample (str): Name of the sample.
    samples_table (pandas.DataFrame): Table containing information about the samples.

    Returns:
    str: Space-separated string of input BAM file names for the sample.
    """
    # Get a set of input BAM file names for the sample from the samples table
    bam_lst = set(samples_table.loc[samples_table["sample"] == str(sample), "inputBam"].to_list())

    # Join the list of BAM file names with a space separator and return the resulting string
    return ' '.join([str(item) for item in bam_lst])


def filter_sample_by_set(Set,samples_Table):
    """
    This function takes a 'set' value as input and returns a dictionary containing
    the unique sample names corresponding to the given 'set' value from a pandas dataframe.
    """
    # Filter the DataFrame to include only rows with the desired 'merged_sample' value
    filtered_rows = samples_Table[samples_Table['set'] == Set]

    # Convert the 'sample' column from 'filtered_rows' to a list, remove duplicates by converting it to a set and then back to a list
    unique_samples = list(set(filtered_rows['sample'].tolist()))

    # Create the dictionary containing the filtered samples
    result = {sample: unique_samples}

    # Return the dictionary containing the filtered samples
    return result
