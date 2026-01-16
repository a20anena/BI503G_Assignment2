nextflow.enable.dsl=2
params.inputFile = null
params.cutoff = 0.5

process gc_filter {

    input:
    path fastaFile
    val cutoff

    output:
    path "output.txt"

    script:
    """
    python3 - << 'EOF'
fasta = "${fastaFile}"
cutoff = float("${cutoff}")

def gc(seq):
    seq = seq.upper()
    if len(seq) == 0:
        return 0
    return (seq.count('G') + seq.count('C')) / len(seq)

out = open("output.txt", "w")
name = None
seq = ""

for line in open(fasta):
    line = line.strip()
    if line.startswith(">"):
        if name and gc(seq) > cutoff:
            out.write(name + "\\n")
            out.write(seq + "\\n")
        name = line
        seq = ""
    else:
        seq += line

if name and gc(seq) > cutoff:
    out.write(name + "\\n")
    out.write(seq + "\\n")

out.close()
EOF
    """
}

workflow {
    reads = Channel.fromPath(params.inputFile)
    gc_filter(reads, params.cutoff)
}





