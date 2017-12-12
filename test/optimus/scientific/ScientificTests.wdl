
# note that this is not a great test because it localizes the .bam file
# however it is a good placeholder while we put together the scientific tests
# themselves, as these files will be relatively small in the testing data.
task TestBamRecordNumber {
  File bam
  Int expected_records
  Int required_disk = ceil(size(bam, "G") * 2)

  command {
    N_RECORDS=$(samtools view "${bam}" | wc -l)
    if [ $N_RECORDS != "${expected_records}" ]; then
        >&2 echo "Number of records in the pipeline output ($N_RECORDS) did not match the expected number (${expected_records})"
        exit 1
    fi
  }
  
  runtime {
    docker: "humancellatlas/samtools:1.3.1"
    cpu: 1
    memory: "3.75 GB"
    disks: "local-disk ${required_disk} HDD"
  }
}