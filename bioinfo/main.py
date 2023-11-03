
import dna_hidden_messages

# dna = utils.readfile_dna_file_txt('dataset_7_10.txt')
# print(min_skew_position('CATTCCAGTACTTCGATGATGGCGTGAAGA'))

# dna = utils.readfile_2_lines('dataset_9_3.txt')
# strand_1 = 'CAGAAAGGAAGGTCCCCATACACCGACGCACCAGTTTA'
# strand_2 = 'CACGCCGTATGCATAAACGAGCCGCACGAACCAGAGAG'
# print(hamming_distance(strand_1, strand_2))


# dna = utils.readfile_2_lines('dataset_9_4.txt')
# pattern = dna[0]
# strand = dna[1]
# result = approximate_pattern_matching(strand, pattern, 5)
# print(utils.get_values_from_list(result))

 
# dna = utils.readfile_2_lines('dataset_9_6.txt')
# pattern = dna[0]
# strand = dna[1]
# print(count_occurences_mismatches('TACGCATTACAAAGCACA', 'AA', 1))


# dna = utils.readfile_2_lines('dataset_9_9.txt')
# strand = dna[0]
# print(len(frequent_words_with_mismatches('TGCAT', 5, 2)))
# for gene in frequent_words_with_mismatches('ACGTTGCATGTCGCATGATGCATGAGAGCT', 4, 1):
#     print(count_occurences_mismatches(
#         'ACGTTGCATGTCGCATGATGCATGAGAGCT', gene, 3))


# p = dna_hidden_messages.number_of_occurences(500, 1000, 9, 0.25)
# print(p)

def HammingDistance(p, q):
    count = 0
    for i in range(0, len(p)):
        if p[i] != q[i]:
            count += 1

    return count


def Neighbors(Pattern, d):
    if d == 0:
        return [Pattern]
    elif len(Pattern) == 1:
        return ['A', 'C', 'G', 'T']
    Neighborhood = []
    Suffix_Pattern = Pattern[1:]
    FirstSymbol_Pattern = Pattern[0]

    SuffixNeighbors = Neighbors(Suffix_Pattern, d)
    for Text in SuffixNeighbors:
        if HammingDistance(Suffix_Pattern, Text) < d:
            for nucleotide in ['A', 'C', 'G', 'T']:
                Neighborhood.append(nucleotide+Text)
        else:
            Neighborhood.append(FirstSymbol_Pattern+Text)
    return Neighborhood


# Write your MotifEnumeration() function here along with any subroutines you need.
# This function should return a list of strings.
def MotifEnumeration(dna, k, d):
    patterns = []
    for i in range(0, len(dna[0])-k+1):
        neighbors = Neighbors(dna[0][i:i+k], d)
        for j in neighbors:
            count = 0
            for l in dna:
                for i in range(0, len(l)-k+1):
                    if HammingDistance(j, l[i:i+k]) <= d:
                        count += 1
                        break
            if count == len(dna):
                patterns.append(j)
    Patterns = []
    [Patterns.append(x) for x in patterns if x not in Patterns]
    Result = ""
    for item in Patterns:
        Result = Result + " " + str(item)
    return Result

# Example usage
Dna = ['ATTTGGC', 'TGCCTTA', 'CGGTATC', 'GAAAATT']
k = 3
d = 1
patterns = MotifEnumeration(Dna, k, d)
print(patterns)
