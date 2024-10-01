# UCU_VisualSearch
This set of scripts and functions runs the three different types of
visual search experiments. You run an experiment with:    

`run_vs(<student>,<settingsnr>,<debug>)`

The arguments mean the following:    
- `student` is used to dissociate between the three experiments. Use `'BH'`,`'NS'`, 
or `'RB'` respectively.         
- `settingsnr` is used to make it possible to have different settingsfiles per
experiment. You can omit it, in which case the code will assume `1`. In all 
other cases, the code will look for a settings file `settings_<student>_<settingsnr>.m`, 
for instance `settings_BH_1.m`.    
- `debug` is used to test the code. It will not show the experiment fullscreen. 
You can omit it, and it will be `false` by default when running the exp.
- Example: `run_vs('BH',1,0)`    

## SEARCH TASK

### run_vs.m   
This is the core function that controls the flow of the experiment. Internally 
it can dissociate between the three experiments by calling different subfunctions 
(explained below). Changes in this script effect ALL experiments.    

### settings  
`settings_<student>_<settingsnr>` defines the specifcs for each experiment. You should all have your own, or maybe 
even multiple settingsfiles. I have created initial ones to show what they 
should look like but these are not the settings you need to use. You can play 
a bit with these and come up with your own specific settings.   

Structurally these are somewhat similar but details are distinct for the different
experiments.     

### procstim
`procstim_<student>` processes the settings file and prepares the stimuli.
These are again specific for a student experiment.

### drawstim    
`drawstim_<student>` draws the stimuli on the screen.
These are again specific for a student experiment.

### write_csv
The log file with all the information is saved as a matlab `.mat` file. The 
filename will be `<PP>_<YYYYMMDD_HHMM>.mat` with `PP` indicating participant initials 
and `YYYYMMDD_HHMM` indicating a time label with minute precision. NB! logs with 
the same initials that are generated in the same minute are overwriting previous 
logs! In addition `write_csv_<student>` generates a csv file that might be 
useful for using in statistics software like JASP. These are again student 
specific so check the files to see what is what. 

## COLOR-REWARD TASK

### run_colrew.m   
This is the core function that controls the flow of the experiment. It's pretty similar 
to `run_vs` with some adjustments.


### settings  
`settings_colrew_<settingsnr>` defines the specifcs for each experiment. You can 
multiple settingsfiles. I have created an initial one to show what they 
should look like but these are not the settings you need to use. You can play 
a bit with these and come up with your own specific settings.      

### procstim
`procstim_colrew` processes the settings file and prepares the stimuli.
These are again specific for a student experiment.

### drawstim    
`drawstim_colrew` draws the stimuli on the screen.
These are again specific for a student experiment.

### write_csv
The log file with all the information is saved as a matlab `.mat` file. The 
filename will be `<PP>_<YYYYMMDD_HHMM>.mat` with `PP` indicating participant initials 
and `YYYYMMDD_HHMM` indicating a time label with minute precision. NB! logs with 
the same initials that are generated in the same minute are overwriting previous 
logs! In addition `write_csv_colrew` generates a csv file that might be 
useful for using in statistics software like JASP. These are again student 
specific so check the files to see what is what. 
