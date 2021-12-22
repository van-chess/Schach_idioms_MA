import pandas as pd

filename = "C:/Users/Vanessa/Desktop/Masterarbeit/MA_repository/Schach_idioms_repository/sentences_and_context_clean_full_removed_htmltag_131221.tsv" # new text with domain_name
csv_input = pd.read_csv(filename, sep="\t", header=0)

grouped = csv_input.groupby(csv_input.domain_id)

idioms_a = grouped.get_group("a")
idioms_a.to_csv('a_domain.tsv', sep="\t", index= False)
print("dataframe lenghth: ", len(idioms_a))

idioms_b = grouped.get_group("b")
idioms_b.to_csv('b_domain.tsv', sep="\t", index= False)
print("dataframe lenghth: ", len(idioms_b))

idioms_c = grouped.get_group("c")
idioms_c.to_csv('c_domain.tsv', sep="\t", index= False)
print("dataframe lenghth: ", len(idioms_c))

idioms_e = grouped.get_group("e")
idioms_e.to_csv('e_domain.tsv', sep="\t", index= False)
print("dataframe lenghth: ", len(idioms_e))

idioms_f = grouped.get_group("f")
idioms_f.to_csv('f_domain.tsv', sep="\t", index= False)
print("dataframe lenghth: ", len(idioms_f))

idioms_i = grouped.get_group("i")
idioms_i.to_csv('i_domain.tsv', sep="\t", index= False)
print("dataframe lenghth: ", len(idioms_i))

idioms_k = grouped.get_group("k")
idioms_k.to_csv('k_domain.tsv', sep="\t", index= False)
print("dataframe lenghth: ", len(idioms_k))

idioms_m = grouped.get_group("m")
idioms_m.to_csv('m_domain.tsv', sep="\t", index= False)
print("dataframe lenghth: ", len(idioms_m))

idioms_n = grouped.get_group("n")
idioms_n.to_csv('n_domain.tsv', sep="\t", index= False)
print("dataframe lenghth: ", len(idioms_n))

idioms_o = grouped.get_group("o")
idioms_o.to_csv('o_domain.tsv', sep="\t", index= False)
print("dataframe lenghth: ", len(idioms_o))

idioms_p = grouped.get_group("p")
idioms_p.to_csv('p_domain.tsv', sep="\t", index= False)
print("dataframe lenghth: ", len(idioms_p))

idioms_r = grouped.get_group("r")
idioms_r.to_csv('r_domain.tsv', sep="\t", index= False)
print("dataframe lenghth: ", len(idioms_r))

idioms_s = grouped.get_group("s")
idioms_s.to_csv('s_domain.tsv', sep="\t", index= False)
print("dataframe lenghth: ", len(idioms_s))