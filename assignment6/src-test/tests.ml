open Base_quickcheck
open Core
open OUnit2
open Ngrams_tests
open Utils

module Student_tests =
struct

  let sample_test_with_test_txt =
    let words = "brown fox jumps" in
    let generated = "over the lazy dog the quick" in
    test_sample 3 "text.txt" 9 (String.split ~on:' ' words) [ words ^ " " ^ generated ]

  let sample_test_two =
    let words = "brown fox jumps" in
    let generated = "" in
    test_sample 5 "text.txt" 3 (String.split ~on:' ' words) [ words ^ "" ^ generated ]

  let frequency_test_text = 
    test_frequency 5 "text.txt" 6 "(((ngram(brown fox jumps over the))(frequency 16))((ngram(fox jumps over the lazy))(frequency 16))((ngram(jumps over the lazy dog))(frequency 16))((ngram(quick brown fox jumps over))(frequency 16))((ngram(the quick brown fox jumps))(frequency 16))((ngram(dog the quick brown fox))(frequency 15)))"

    let test_add_sequence_and_find _ =
      let ngram_data = StringNGram.empty in
      let ngram_data = StringNGram.add_sequence ngram_data ["hello"; "world"] "again" in
      let ngram_data = StringNGram.add_sequence ngram_data ["hello"; "world"] "everyone" in
      let ngram_data = StringNGram.add_sequence ngram_data ["hello"; "world"] "again" in

      (* Test find *)
      let found = StringNGram.find ngram_data ["hello"; "world"] in
      assert_equal (Option.is_some found) true;
      assert_equal (List.length (Option.value_exn found)) 3;
      assert_equal (List.mem (Option.value_exn found) "again" ~equal:String.equal) true;
      assert_equal (List.mem (Option.value_exn found) "everyone" ~equal:String.equal) true;;

      let test_sanitize_string _ =
        let input = "   Hello, World!! " in
        let sanitized = sanitize_string input in
        assert_equal sanitized "helloworld"
  
      (* Test sanitization of a sequence *)
      let test_sanitize_sequence _ =
        let input = [" Hello "; " World! "] in
        let sanitized = sanitize_sequence input in
        assert_equal sanitized ["hello"; "world"]
  
      (* Test removing empty strings *)
      let test_remove_empty_strings _ =
        let input = ["hello"; "world"; ""] in
        let result = remove_empty_strings input in
        assert_equal result ["hello"; "world"]

          let test_count_ngrams _ =
            let ngram_data = StringNGram.empty in
            let ngram_data = StringNGram.add_sequence ngram_data ["hello"; "world"] "again" in
            let ngram_data = StringNGram.add_sequence ngram_data ["hello"; "world"] "everyone" in
            let counts = StringNGram.count_ngrams ngram_data in
            let count_hello_world_again = Map.find counts ["hello"; "world"; "again"] in
            let count_hello_world_everyone = Map.find counts ["hello"; "world"; "everyone"] in
            assert_equal (Option.value_exn count_hello_world_again) 1;
            assert_equal (Option.value_exn count_hello_world_everyone) 1
      
          (* Test sampling random element from n-grams *)
          let test_sample_random _ =
            let choices = ["apple"; "banana"; "cherry"] in
            let _ = StringNGram.sample_random choices in
            assert_equal (List.mem choices (StringNGram.sample_random choices) ~equal:String.equal) true
      
          (* Test sampling sequence *)
          let test_sample_sequence _ =
            let ngram_data = StringNGram.empty in
            let ngram_data = StringNGram.add_sequence ngram_data ["hello"; "world"] "again" in
            let result = sample_sequence ngram_data ["hello"; "world"] 3 ["hello"; "world"] in
            assert_equal result ["hello"; "world"; "again"]

            let test_read_corpus _ =
              let words = read_corpus "../test/test_corpus.txt" in
              assert_equal words ["this"; "is"; "a"; "test"; "corpus"]

              (* Test for create_string_ngram *)
  let test_create_string_ngram_edge _ =
    (* Edge case: empty word list *)
    let ngram_data = Utils.create_string_ngram [] 2 in
    assert_equal 0 (Map.length ngram_data);

    (* Edge case: not enough words to form an n-gram *)
    let ngram_data = Utils.create_string_ngram ["word1"] 2 in
    assert_equal 0 (Map.length ngram_data);

    (* Edge case: exactly enough words to form an n-gram *)
    let ngram_data = Utils.create_string_ngram ["word1"; "word2"] 2 in
    let context = ["word1"] in
    match StringNGram.find ngram_data context with
    | Some words -> assert_equal ["word2"] words
    | None -> assert_failure "No words found for context"

    let test_sample_sequence_edge _ =
      (* Edge case: empty n-gram map *)
      let empty_ngram_data = StringNGram.empty in
      let sampled = Utils.sample_sequence empty_ngram_data ["it"; "is"] 4 [] in
      assert_equal [] sampled;
  
      (* Edge case: no matching context *)
      let ngram_data = Utils.create_string_ngram ["this"; "is"; "a"; "test"] 2 in
      let sampled = Utils.sample_sequence ngram_data ["not"; "present"] 4 [] in
      assert_equal [] sampled

      (* Quickcheck test for the sanitize_string function *)
      let test_sanitize_string_quickcheck _ =
        (* Use the correct Quickcheck generator for strings *)
        Quickcheck.test
          (Generator.string)  (* Correct usage of Base_quickcheck.Generator.string *)
          ~f:(fun random_str ->
            let sanitized = sanitize_string random_str in
      
            (* INVARIANT: Check that the sanitized string contains only lowercase alphanumeric characters. *)
            assert_bool "Sanitized string contains non-alphanumeric characters"
              (String.for_all sanitized ~f:(fun ch -> Char.is_alphanum ch));
      
            (* INVARIANT: Ensure the sanitized string has no leading or trailing whitespace *)
            assert_equal sanitized (String.strip sanitized);
      
            (* INVARIANT: Ensure the sanitized string is entirely lowercase *)
            assert_equal sanitized (String.lowercase sanitized)
          )

  let series =
    "Student tests" >::: 
    [ test_case sample_test_with_test_txt;
      test_case sample_test_two;
      test_case frequency_test_text;
      test_case test_add_sequence_and_find;
      test_case test_sanitize_string;
      test_case test_sanitize_sequence;
      test_case test_remove_empty_strings;
      test_case test_sample_sequence;
      test_case test_sample_random;
      test_case test_count_ngrams;
      test_case test_read_corpus;
      test_case test_create_string_ngram_edge;
      test_case test_sample_sequence_edge;
      test_case test_sanitize_string_quickcheck ]
end

let series =
  "Assignment 6 tests" >:::
  [ Student_tests.series
  ; Ngrams_tests.series ]

let () = run_test_tt_main series