def array_of_years_of_datas(data):
    years_of_datas = [[0 for x in range(31)] for y in range(59)]
    while j < len(data):
        years_of_datas[][]


with open ("T2m_HANOI_1961_2019.txt", "r") as myfile:
    data = myfile.read().splitlines() # Print it into an array of lines 
    for i in range(3):
        data.pop(0)  # Drop the first 3 meaningless entries!
    print(data[0])  # Check Check
    matrix_1961 = [[0 for x in range(12)] for y in range(31)]   # Matrix 31x12
    j = 0
    while j < len(data):
        a_line_split = data[j].split("  ") # Array: 
        first_entry_of_a_line_split = a_line_split.pop(0)  # Date of the line 
        for h in range(len(a_line_split)):
            a_value_without_whitespace = a_line_split[h].strip()
            a_line_split[h] = a_value_without_whitespace
        matrix_1961[j] = a_line_split
        if(first_entry_of_a_line_split == '31'):  # Signal the end of a year
            break
        j = j + 1

    

    print("Matrix 1961 after loop")
    print(matrix_1961)

    matrix_1961_transposed = [[0 for x in range(31)] for y in range(12)]   # Matrix 12x31

    for a in range(len(matrix_1961)):
        for b in range(len(matrix_1961[a])):
            matrix_1961_transposed[b][a] = matrix_1961[a][b]

    print("Matrix 1961 after transposition")
    print(len(matrix_1961_transposed))
    print(len(matrix_1961_transposed[0]))
    print(matrix_1961_transposed)


        
        

        
    

