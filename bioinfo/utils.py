def readfile_2_lines(file):
    text = None
    k = None
    with open(file, 'r') as f:
        lines = f.readlines()
        text = lines[0]
        k = lines[1]
    return text, k


def readfile_dna_file_txt(file):
    with open(file, 'r') as f:
        lines = f.readline()
    return lines


def get_values_from_list(list_result):
    return ' '.join(map(str, list_result))
