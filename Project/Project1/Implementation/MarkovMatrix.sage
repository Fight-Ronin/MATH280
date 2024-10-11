# Step 1: Process Text Files and Extract T tones from input text
def extract_tones_from_string(input_text):
    """
    Extract tones from a given input text string and return a list of sequences of tones.
    Each tone is represented as an integer (1-5) based on the numbered pinyin syllables.
    """
    tones = []
    lines = input_text.split('\n')
    for line in lines:
        line_tones = [int(word[-1]) for word in line.split() if word[-1].isdigit()]
        tones.append(line_tones)
    return tones

# Step 2: Construct a Markov Matrix Using SageMath
def construct_markov_matrix(tones_list, num_states=5):
    """
    Create a SageMath Markov matrix for a given list of tone sequences.
    The matrix is normalized to represent transition probabilities.
    """
    # Initialize a num_states x num_states matrix with all entries set to zero
    transition_counts = Matrix(SR, num_states, num_states, 0)

    # Count transitions based on tone sequences
    for tones in tones_list:
        for i in range(len(tones) - 1):
            current_tone = tones[i] - 1
            next_tone = tones[i + 1] - 1
            transition_counts[current_tone, next_tone] += 1

    # Normalize the matrix rows to get transition probabilities
    for i in range(num_states):
        row_sum = sum(transition_counts[i, j] for j in range(num_states))
        if row_sum > 0:
            for j in range(num_states):
                transition_counts[i, j] /= row_sum

    return transition_counts

# Step 3: Compute the Log-Likelihood of a Given Sequence Under a Markov Matrix
def compute_log_likelihood(matrix, test_tones):
    """
    Calculate the log-likelihood of a sequence of tones given a SageMath Markov matrix.
    """
    log_likelihood = 0
    for i in range(len(test_tones) - 1):
        current_state = test_tones[i] - 1
        next_state = test_tones[i + 1] - 1
        probability = matrix[current_state, next_state]
        if probability > 0:
            log_likelihood += log(probability)
        else:
            log_likelihood += float('-inf')  # Log(0) is -infinity
    return log_likelihood

# Step 4: Predict the Author of a Given Text
def guess_author(test_tones, matrix_zhu, matrix_du):
    """
    Guess the author based on the log-likelihood of the test tones under each author's Markov matrix.
    """
    likelihood_zhu = compute_log_likelihood(matrix_zhu, test_tones)
    likelihood_du = compute_log_likelihood(matrix_du, test_tones)
    
    if likelihood_zhu > likelihood_du:
        return "Zhu Shuzhen"
    else:
        return "Du Fu"

# Sample Input (as given)
input_text = """
mei2 hua1 zhi1 shang4 xue3 chu1 rong2
yi1 ye4 gao1 feng1 ji1 zhuan3 dong1
fang11 cao3 chi2 tang2 bing1 wei4 bo2
liu3 tiao2 ru2 xian4 zhao2 chun1 gong1
ting2 bei1 bu4 yin3 dai4 chun1 lai2
he2 qi0 xian1 chun1 dong4 liu4 jie1
sheng1 cai4 zha4 tiao1 yi2 juan3 bing3
luo2 fan1 xuan4 jian3 cheng lian2 chai1
xiu1 lun4 can2 la4 qian1 zhong4 hen4
guan3 ru4 xin1 nian2 bai3 shi4 xie2
cong2 ci3 dui4 hua1 bing4 dui4 jing3
jin4 ju1 feng1 yue4 ru4 shi1 huai2
"""

# Step 1: Extract tones from the input text
tones_data = extract_tones_from_string(input_text)

# Create a training set and a test set manually for demonstration
# Assume first half belongs to Du Fu and second half to Zhu Shuzhen for illustration
df_tones = tones_data[:len(tones_data)//2]
zsz_tones = tones_data[len(tones_data)//2:]

# Construct Markov matrices for each poet
matrix_df = construct_markov_matrix(df_tones)
matrix_zsz = construct_markov_matrix(zsz_tones)

# Display the matrices using print statements
print("Du Fu's Markov Matrix:")
print(matrix_df)
print("\nZhu Shuzhen's Markov Matrix:")
print(matrix_zsz)

# Assume test sequences (can be replaced with other sequences for real testing)
test_tones_df = df_tones[0]  # Use first sequence from Du Fu's data as test example
test_tones_zsz = zsz_tones[0]  # Use first sequence from Zhu Shuzhen's data as test example

# Validate against test texts and guess the author
print("\nPredicted author for Du Fu's test tones: ", guess_author(test_tones_df, matrix_zsz, matrix_df))
print("Predicted author for Zhu Shuzhen's test tones: ", guess_author(test_tones_zsz, matrix_zsz, matrix_df))
