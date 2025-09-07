python : Traceback (most recent call last):
At line:1 char:1
+ python C:\Users\Tata\dev\chest-of-drawers-bookcase\split_layers.py C: ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (Traceback (most recent call last)::String  
   ) [], RemoteException
    + FullyQualifiedErrorId : NativeCommandError

  File "C:\Users\Tata\dev\chest-of-drawers-bookcase\split_layers.py", line 828, in <mod 
ule>
    main()
    ~~~~^^
  File "C:\Users\Tata\dev\chest-of-drawers-bookcase\split_layers.py", line 825, in main 
    split_layers(input_file, output_file)
    ~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^
  File "C:\Users\Tata\dev\chest-of-drawers-bookcase\split_layers.py", line 714, in spli 
t_layers
    add_title(msp, panel_name, final_bbox_before_title)
    ~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "C:\Users\Tata\dev\chest-of-drawers-bookcase\split_layers.py", line 577, in add_ 
title
    text.set_pos((title_x, title_y), align='MIDDLE_CENTER')
    ^^^^^^^^^^^^
AttributeError: 'Text' object has no attribute 'set_pos'
PS C:\Users\Tata\dev\chest-of-drawers-bookcase> 