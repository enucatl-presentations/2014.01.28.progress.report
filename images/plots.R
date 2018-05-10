#!/usr/bin/env Rscript

library(argparse)
library(gridExtra)
library(ggplot2)
library(data.table)
library(RSvgDevice)
library(SVGAnnotation)

commandline_parser = ArgumentParser(
        description="draw results for fit analysis") 

commandline_parser$add_argument('-f', '--file',
            type='character', nargs='?', default='data_analysis.rda')

args = commandline_parser$parse_args()
load(args$f) #constant_analysis, visibility_analysis
setkeyv(constant_analysis, c("stat", "algorithm"))
setkeyv(visibility_analysis, c("stat", "algorithm"))

theme_set(theme_bw(base_size=10) + theme(
legend.key.size=unit(1, 'lines'),
text=element_text(face='plain', family='CM Roman'),
legend.title=element_text(face='plain'),
axis.line=element_line(color='black'),
axis.title.y=element_text(vjust=0.1),
axis.title.x=element_text(vjust=0.1),
panel.grid.major = element_blank(),
panel.grid.minor = element_blank(),
panel.border = element_blank()
))


names = c("mean", "median", "sd", "kurtosis", "skewness")
english = list(mean="media",
               median="mediana",
               sd="deviazione std",
               kurtosis="curtosi",
               skewness="asimmetria")
english = list(mean="mean",
               median="median",
               sd="std deviation",
               kurtosis="kurtosis",
               skewness="skewness")

y_scales = list(
              mean=c(scale_y_continuous, scale_y_continuous,
                     scale_y_continuous, scale_y_log10),
              median=c(scale_y_continuous, scale_y_continuous,
                     scale_y_continuous, scale_y_log10),
              sd=c(scale_y_log10, scale_y_log10,
                     scale_y_log10, scale_y_continuous),
              kurtosis=c(scale_y_continuous, scale_y_continuous,
                     scale_y_continuous, scale_y_continuous),
              skewness=c(scale_y_continuous, scale_y_continuous,
                     scale_y_continuous, scale_y_continuous)
              )
x_scales = list(
              mean=c(scale_x_log10, scale_x_log10,
                     scale_x_log10, scale_x_log10),
              median=c(scale_x_log10, scale_x_log10,
                     scale_x_log10, scale_x_log10),
              sd=c(scale_x_continuous, scale_x_continuous,
                     scale_x_continuous, scale_x_continuous),
              kurtosis=c(scale_x_log10, scale_x_log10,
                     scale_x_log10, scale_x_log10),
              skewness=c(scale_x_log10, scale_x_log10,
                     scale_x_log10, scale_x_log10)
              )


for(statistical_test in names) {
    image_name = sprintf("stats_phase_constant_%s.svg", statistical_test)
    dimension <- 5
    factor <- 0.55
    svg(image_name, width=dimension, height=(dimension * factor))
    graph_phase_constant = ggplot(constant_analysis[J(statistical_test)],
                        aes(x=true_constant,
                            y=phase,
                            color=algorithm,
                            linetype=as.factor(true_visibility)
                            )) + geom_line(
                        aes(group=interaction(algorithm, true_visibility)))
    graph_phase_constant = graph_phase_constant + y_scales[[statistical_test]][[1]](
                                name=sprintf("%s phase",
                                             english[[statistical_test]])
                                ) + scale_linetype_discrete(
                                name="visibility") +
                                x_scales[[statistical_test]][[1]](name="constant"
                                ) + scale_colour_discrete(name="algorithm",
                                breaks=c("fft", "ls"), labels=c("fft", "weighted fit"))
    print(graph_phase_constant)
    dev.off()
    doc = xmlParse(image_name)
    addCSS(doc, css='css/plots.css')
    saveXML(doc, image_name)
    image_name = sprintf("stats_phase_visibility_%s.svg", statistical_test)
    svg(image_name, width=dimension, height=dimension * factor)
    graph_phase_visibility = ggplot(visibility_analysis[J(statistical_test)],
                        aes(x=true_visibility,
                            y=phase,
                            color=algorithm,
                            linetype=as.factor(true_constant),
                            )) + geom_line(
                        aes(group=interaction(algorithm, true_constant)))
    graph_phase_visibility = graph_phase_visibility + y_scales[[statistical_test]][[2]](
                                name=sprintf("%s phase",
                                             english[[statistical_test]])
                                ) + scale_linetype_discrete(name="constant"
                                ) + x_scales[[statistical_test]][[2]](
                                name="visibility"
                                ) + scale_colour_discrete(name="algorithm",
                                breaks=c("fft", "ls"), labels=c("fft", "weighted fit"))
    print(graph_phase_visibility)
    dev.off()
    doc = xmlParse(image_name)
    addCSS(doc, css="css/plots.css")
    saveXML(doc, image_name)
    image_name = sprintf("stats_visibility_constant_%s.svg", statistical_test)
    svg(image_name, width=dimension, height=dimension * factor)
    graph_visibility_constant = ggplot(constant_analysis[J(statistical_test)],
                        aes(x=true_constant,
                            y=visibility,
                            color=algorithm,
                            linetype=as.factor(true_visibility),
                            )) + geom_line(
                        aes(group=interaction(algorithm, true_visibility)))
    graph_visibility_constant = graph_visibility_constant + y_scales[[statistical_test]][[3]](
                                name=sprintf("%s visibility",
                                             english[[statistical_test]])
                                ) + scale_linetype_discrete(name="visibility"
                                ) + x_scales[[statistical_test]][[3]](name="constant"
                                ) + scale_colour_discrete(name="algorithm",
                                breaks=c("fft", "ls"), labels=c("fft", "weighted fit"))
    print(graph_visibility_constant)
    dev.off()
    doc = xmlParse(image_name)
    addCSS(doc, css="css/plots.css")
    saveXML(doc, image_name)
    image_name = sprintf("stats_visibility_visibility_%s.svg", statistical_test)
    svg(image_name, width=dimension, height=dimension * factor)
    graph_visibility_visibility = ggplot(visibility_analysis[J(statistical_test)],
                        aes(x=true_visibility,
                            y=visibility,
                            color=algorithm,
                            linetype=as.factor(true_constant),
                            )) + geom_line(
                        aes(group=interaction(algorithm, true_constant)))
    graph_visibility_visibility = graph_visibility_visibility + y_scales[[statistical_test]][[4]](
                                name=sprintf("%s visibility",
                                             english[[statistical_test]])
                                ) + scale_linetype_discrete(name="constant"
                                ) + x_scales[[statistical_test]][[4]](name="visibility"
                                ) + scale_colour_discrete(name="algorithm",
                                breaks=c("fft", "ls"), labels=c("fft", "weighted fit"))
    print(graph_visibility_visibility)
    dev.off()
    doc = xmlParse(image_name)
    addCSS(doc, css="css/plots.css")
    saveXML(doc, image_name)
}
print(sprintf(
              " Parameters for all the plots
               phase steps = %i
               phase value = %.2f
               simulated curves per point = %i
               poisson noise
               ", steps, phase, n)) 
warnings()
