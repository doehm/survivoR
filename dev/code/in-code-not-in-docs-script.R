in_code <- "castaway castaway_id p_score_adv p_score_chal_all
          p_score_chal_duel p_score_chal_immunity p_score_chal_individual
          p_score_chal_individual_immunity p_score_chal_individual_reward
          p_score_chal_reward p_score_chal_team
          p_score_chal_team_immunity p_score_chal_team_reward
          p_score_chal_tribal p_score_chal_tribal_immunity
          p_score_chal_tribal_reward p_score_challenge p_score_inf
          p_score_jury p_score_result p_score_vote r_score_adv
          r_score_chal_all r_score_chal_duel r_score_chal_immunity
          r_score_chal_individual r_score_chal_individual_immunity
          r_score_chal_individual_reward r_score_chal_reward
          r_score_chal_team r_score_chal_team_immunity
          r_score_chal_team_reward r_score_chal_tribal
          r_score_chal_tribal_immunity r_score_chal_tribal_reward
          r_score_challenge r_score_inf r_score_jury r_score_result
          r_score_vote score_adv score_challenge score_inf score_jury
          score_outlast score_outplay score_outwit score_overall
          score_result score_vote threat_challenge threat_challenge_cat
          threat_strategic threat_strategic_cat version version_season"

in_docs <- "castaway castaway_id p_score_adv p_score_chal_all
          p_score_chal_duel p_score_chal_immunity p_score_chal_individual
          p_score_chal_individual_immunity p_score_chal_individual_reward
          p_score_chal_reward p_score_chal_team
          p_score_chal_team_immunity p_score_chal_team_reward
          p_score_chal_tribal p_score_chal_tribal_immunity
          p_score_chal_tribal_reward p_score_inf p_score_jury
          p_score_result p_score_vote r_score_adv r_score_chal_all
          r_score_chal_duel r_score_chal_immunity r_score_chal_individual
          r_score_chal_individual_immunity r_score_chal_individual_reward
          r_score_chal_reward r_score_chal_team
          r_score_chal_team_immunity r_score_chal_team_reward
          r_score_chal_tribal r_score_chal_tribal_immunity
          r_score_chal_tribal_reward r_score_inf r_score_jury
          r_score_result r_score_vote score_adv score_challenge score_inf
          score_jury score_outlast score_outplay score_outwit
          score_overall score_result score_vote season threat_challenge
          threat_challenge_cat threat_strategic threat_strategic_cat
          version version_season"

in_code <- str_split_1(in_code, " ")
in_code <- in_code[in_code != ""]
in_code <- str_remove(in_code, "\n")

in_docs <- str_split_1(in_docs, " ")
in_docs <- in_docs[in_docs != ""]
in_docs <- str_remove(in_docs, "\n")

# in code not in docs
in_code[!in_code %in% in_docs]

# in docs not in code
in_docs[!in_docs %in% in_code]


