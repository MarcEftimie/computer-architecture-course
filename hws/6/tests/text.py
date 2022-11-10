words = []
word = ''
for i in range(1, 32):
    word = i
    if i < 10:
        word = f'0{i}'
    words.append("x%s <= decoder_out[%s] ? wr_data : x%s;" % (word, i, word))
print('\n'.join(words))