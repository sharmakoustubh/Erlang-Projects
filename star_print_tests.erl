-module(star_print_tests).
-export([star_print_alltests/0]).

star_print_alltests()->

    star_print_filepath_test(),
    star_print_no_file_exist_filepath(), 
    star_print_non_integer_rows_test_with_filepath(), 
    star_print_wrong_file_format_filepath(), 
    star_print_two_three_test(),
    star_print_three_three_test(),
    star_print_enter_negative_rows_test(),
    star_print_enter_negative_columns_test(),
    star_print_enter_nonprintable_below31_test(),
    star_print_enter_nonprintable_above255_test(),
    ok.

star_print_filepath_test()->
    "**\n**\n"=star_print_X:star_print("C:/Users/ekousha/Documents/Erlang_Projects/filetoread.txt").
star_print_no_file_exist_filepath()->
   {error,"No such file exists"} =star_print_X:star_print("C:/thisdoesnotexist/filetoread.txt").
star_print_non_integer_rows_test_with_filepath()->
    {error, "Rows is not an integer"}=star_print_X:star_print("C:/Users/ekousha/Documents/Erlang_Projects/filetoread_nonintegerrows.txt").

star_print_wrong_file_format_filepath()->
    {error, "incorrect file format"}=star_print_X:star_print("C:/Users/ekousha/Documents/Erlang_Projects/filetoread_morethanthreevalues.txt").

    
star_print_two_three_test()->
    "***\n***\n"=star_print_X:star_print(2,3,$*).

		      
star_print_three_three_test()->
    "***\n***\n***\n"=star_print_X:star_print(3,3,$*).

star_print_enter_negative_rows_test()->
    {error,"negative row or column entry, please enter valid row or column"}=star_print_X:star_print(-3,3,$*).

star_print_enter_negative_columns_test()->
    {error,"negative row or column entry, please enter valid row or column"}=star_print_X:star_print(3,-3,$*).

star_print_enter_nonprintable_below31_test()->
    {error,"please enter printable character"}=star_print_X:star_print(3,3,13).
star_print_enter_nonprintable_above255_test()->
    {error,"please enter printable character"}=star_print_X:star_print(3,3,258).



