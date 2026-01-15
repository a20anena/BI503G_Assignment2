#!/usr/bin/env nextflow

params.inputFile = null
params.cutoff = 0.5

process filterFasta {

    input:
    path fastaFile
    val cutoff

    output:
    path "output.txt"

    script:
    """
    echo "hello" > output.txt
    """
}

workflow {
    fastaChannel = Channel.fromPath(params.inputFile)
    filterFasta(fastaChannel, params.cutoff)
}


