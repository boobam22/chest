import argparse


k9 = "abc|def|ghi|jkl|mno|pqrs|tuv|wxyz"
k26 = "qwertyuiopasdfghjklzxcvbnm"

k9_to_dict = {}
for abc, n in zip(k9.split("|"), "23456789"):
    k9_to_dict.update(zip(abc, n * len(abc)))
k26_to_dict = {k: k26[i - 25] for i, k in enumerate(k26)}


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "str", help="A word containing only lowercase letters, with a length of 3-12"
    )
    str = parser.parse_args().str

    num = "".join([k9_to_dict[i] for i in str])
    print(f"{str}{num*4}"[:14])

    reverse_str = "".join([k26_to_dict[i] for i in reversed(str)])
    num = "".join([k9_to_dict[i] for i in reverse_str])
    print(f"{(reverse_str*2)[:6]}+{(num*2)[:6]}")
