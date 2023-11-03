import utils


def pattern_count(text, pattern, position=False):
    count = 0
    pos = []
    for i in range(0, len(text) - len(pattern) + 1):
        if text[i:i + len(pattern)] == pattern:
            if position:
                pos.append(i)
            count += 1
    return count, pos


def frequency_table(text, k):
    freq_map = {}
    n = len(text)
    for i in range(n-k):
        pattern = text[i:i+k]
        if not freq_map.get(pattern):
            freq_map[pattern] = 1
        else:
            freq_map[pattern] += 1
    return freq_map


def max_map(element):
    maximum = 0
    for key, val in element.items():
        if val < maximum:
            maximum = maximum
        else:
            maximum = val
    return maximum


def better_frequent_words(text, k):
    frequent_patterns = []
    freq_map = frequency_table(text, k)
    maximum = max_map(freq_map)
    for element in freq_map.keys():
        if freq_map[element] == maximum:
            frequent_patterns.append(element)
    return frequent_patterns


def complement_dna_strand(dna_strand):
    bases = {
        'A': 'T',
        'G': 'C',
        'T': 'A',
        'C': 'G'
    }
    new_strand = []
    for _, value in enumerate(dna_strand):
        if bases.get(value):
            new_strand.append(bases.get(value))
    return ''.join(new_strand[::-1])


def skew_diagram(genome):
    """
    skew(i)|genome| ; i -> [0, |genome|]
    skew(0)|genome| = 0 (for genome)
    if G -> skew(i+1)|genome| = skew(i)|genome| + 1
    if C -> skew(i+1)|genome| = skew(i)|genome| - 1
    else skew(i+1)|genome| = skew(i)|genome|
    """
    scew_val = [0]
    map_skew = {
        'A': 0,
        'T': 0,
        'C': -1,
        'G': 1
    }
    for i in range(len(genome)):
        try:
            res = scew_val[i] + map_skew[genome[i]]
            scew_val.append(res)
        except KeyError:
            pass
    return scew_val


def min_skew_position(genome):
    min_val = []
    min_pos = []
    skew_list = skew_diagram(genome)
    for i in range(len(skew_list)):
        if skew_list[i] == min(skew_list):
            min_val.append(skew_list[i])
            min_pos.append(i)
    return min_pos


def hamming_distance(strand_1, strand_2):
    distance = 0
    for i, j in zip(strand_1, strand_2):
        if i != j:
            distance += 1
    return distance


def approximate_pattern_matching(genome, pattern, n):
    position = []
    for i in range(0, len(genome) - len(pattern) + 1):
        new_pattern = genome[i:i + len(pattern)]
        if hamming_distance(new_pattern, pattern) <= n:
            position.append(i)
    return position


def count_occurences_mismatches(genome, pattern, n):
    return len(approximate_pattern_matching(genome, pattern, n))


def neighbors(pattern, d):
    """
    Args:
        pattern: gene
        d: number of mismatches or number of mutation in the gene
    """
    neighborhood = set()
    if d == 0:
        neighborhood.add(pattern)
    elif len(pattern) == 1:
        neighborhood.update(['A', 'C', 'G', 'T'])
    else:
        suffix_neighbors = neighbors(pattern[1:], d)
        for text in suffix_neighbors:
            if hamming_distance(pattern[1:], text) < d:
                for x in ['A', 'C', 'G', 'T']:
                    neighborhood.add(x + text)
            else:
                neighborhood.add(pattern[0] + text)
    return neighborhood


def frequent_words_with_mismatches(text, k, d):
    """
    Args:
        Text: genome
        k: lenght of k-mer
        d: number of mismatches
    """
    patterns = []
    frequency_map = {}
    n = len(text)
    for i in range(n - k + 1):
        pattern = text[i:i+k]
        neighborhood = neighbors(pattern, d)
        for neighbor in neighborhood:
            if neighbor not in frequency_map:
                frequency_map[neighbor] = 1
            else:
                frequency_map[neighbor] += 1
    m = max_map(frequency_map)
    for p in frequency_map:
        if frequency_map[p] == m:
            patterns.append(p)
    return patterns


def number_of_occurences(N, L, k, p):
    """
    Args:

        N : Number of DNA
        L : Lenght of DNA
        k : k-mer
        p : probability that A, C, G, T appear


    Probability to get 9-mer in 500 DNA of lenght 1000
    The probability that A, C, G, T appear is 0.25 for each

    N = 500
    L = 1000
    k = 9
    p = 0.25

    combination of 9-mer = 4^9 = 4**9
    For each A, C, G, T -> (1/4)**9

    From pattern_count() function we know that
    In 1000 there will be L - k + 1 different 9-mer

    Probability is then N * (L - k + 1) * (1/4)**9
    """
    return N * (L - k + 1) * p**9




