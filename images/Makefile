PICTURES = S00618_visibility.json visibility_100kev_visibility.json\
		   stats_phase_constant_kurtosis.svg\
		   stats_phase_visibility_median.svg\
		   stats_visibility_constant_skewness.svg stats_phase_constant_mean.svg\
		   stats_phase_visibility_sd.svg\
		   stats_visibility_visibility_kurtosis.svg stats_phase_constant_median.svg\
		   stats_phase_visibility_skewness.svg     stats_visibility_visibility_mean.svg\
		   stats_phase_constant_sd.svg          stats_visibility_constant_kurtosis.svg\
		   stats_visibility_visibility_median.svg stats_phase_constant_skewness.svg\
		   stats_visibility_constant_mean.svg      stats_visibility_visibility_sd.svg\
		   stats_phase_visibility_kurtosis.svg  stats_visibility_constant_median.svg\
		   stats_visibility_visibility_skewness.svg stats_phase_visibility_mean.svg\
		   stats_visibility_constant_sd.svg\
		   profile_S00400.svg profile_S00613.svg

all: $(PICTURES)

S00618_visibility.json: S00618.hdf5 plot_visibility_pgf.py
	python plot_visibility_pgf.py --steps 25 --pixel 510 $<

visibility_100kev_visibility.json: visibility_100kev.hdf5 plot_visibility_pgf.py
	python plot_visibility_pgf.py --steps 25 --pixel 510 $<

stats_%.svg: plots.R data_analysis.rda
	./plots.R

profile_%.svg: %.hdf5 plot_profile.py 
	python plot_profile.py $<
