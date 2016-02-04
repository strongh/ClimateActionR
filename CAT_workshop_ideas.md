# Colorado River water security from the perspective of Southern California

# Background:
* Potted history of multi-state negotiations over Colorado River water (1920s to present)
http://web.stanford.edu/group/ruralwest/cgi-bin/drupal/content/what-seven-states-can-agree-do-deal-making-colorado-river

* California 4.4 Plan
http://www.crb.ca.gov/programs/Calif_Plan_May_11-Draft.pdf

* Barnett, T. P., & Pierce, D. W. (2009). Sustainable water deliveries from the Colorado River in a changing climate. Proceedings of the National Academy of Sciences, 106(18), 7334-7338.
http://www.pnas.org/content/106/18/7334.short

* Christensen, N. S., Wood, A. W., Voisin, N., Lettenmaier, D. P., & Palmer, R. N. (2004). The effects of climate change on the hydrology and water resources of the Colorado River basin. Climatic change, 62(1-3), 337-363.
http://link.springer.com/article/10.1023/B:CLIM.0000013684.13621.1f

* Christensen, N. S., & Lettenmaier, D. P. (2007). A multimodel ensemble approach to assessment of climate change impacts on the hydrology and water resources of the Colorado River Basin. Hydrology and Earth System Sciences, 11(4), 1417-1434.
http://www.hydrol-earth-syst-sci.net/11/1417/

# Projections of water supply/demand + costs of alternatives
http://www.usbr.gov/watersmart/bsp/docs/finalreport/ColoradoRiver/CRBS_Executive_Summary_FINAL.pdf

# Colorado Basin Water Security
http://www.usbr.gov/lc/region/programs/crbstudy/finalreport/index.html

# Stakeholders (incomplete):
* Colorado River Board (California)
http://www.crb.ca.gov/

* Environmental Defense Fund
http://www.coloradoriverbasin.org/

* Colorado River Water Users Association
http://www.crwua.org/

* International treaty issues:
Legal obligations to deliver water to Mexico
http://www.crb.ca.gov/programs/water-treaty-mexico.html

# Spatial bounds:
* Hydrologic basin boundaries + rivers (shapefiles)
http://www.nohrsc.noaa.gov/gisdatasets/


# Methods:
* Fowler, H. J., Blenkinsop, S., & Tebaldi, C. (2007). Linking climate change modelling to impacts studies: recent advances in downscaling techniques for hydrological modelling. International journal of climatology, 27(12), 1547-1578.
http://climateknowledge.org/downscaling/Fowler_Review_Downscaling_Hydrology_IntJClimatology_2007.pdf

# Hydropower
* Colorado River Hydropower Faces a Dry Future
http://spectrum.ieee.org/energy/renewables/colorado-river-hydropower-faces-a-dry-future

* Mapping drought's impact on electricity generation
http://www.hcn.org/articles/hydropower-california-drought-water-energy-electricity-dams

* Climate-change impacts on water resources and hydropower potential in the Upper Colorado River Basin
http://www.sciencedirect.com/science/article/pii/S221458181500018X

# Software
* Somebody put together a workshop similar to ours:
https://github.com/adammwilson/SpatialAnalysisTutorials

* I don’t know a lot about ArcGIS, but it looks like there are standardized APIs for accessing data via a variety of clients, including R. For example, the EnviroAtlas has a lot of data that could be relevant. The data is available through a browsable ArcGIS API here:
http://enviroatlas.epa.gov/arcgis/rest/services

* I haven’t tried it, but it looks like R has a client library for ArcGIS:
https://r-arcgis.github.io/

* Setting up access to an API like this could make it easier for us to provide access to a wide variety of data sources. We can still build tools for easy usage, but by providing data through an API we can essentially include a lot more data sources. 