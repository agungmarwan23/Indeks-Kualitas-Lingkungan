var wms_layers = [];


        var lyr_GoogleHybrid_0 = new ol.layer.Tile({
            'title': 'Google Hybrid',
            //'type': 'base',
            'opacity': 1.000000,
            
            
            source: new ol.source.XYZ({
    attributions: ' &middot; <a href="https://www.google.at/permissions/geoguidelines/attr-guide.html">Map data ©2015 Google</a>',
                url: 'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}'
            })
        });
var format_IKLHKab2023_1 = new ol.format.GeoJSON();
var features_IKLHKab2023_1 = format_IKLHKab2023_1.readFeatures(json_IKLHKab2023_1, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_IKLHKab2023_1 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_IKLHKab2023_1.addFeatures(features_IKLHKab2023_1);
var lyr_IKLHKab2023_1 = new ol.layer.Vector({
                declutter: false,
                source:jsonSource_IKLHKab2023_1, 
                style: style_IKLHKab2023_1,
                popuplayertitle: "IKLH Kab 2023",
                interactive: true,
    title: 'IKLH Kab 2023<br />\
    <img src="styles/legend/IKLHKab2023_1_0.png" /> Sangat Baik<br />\
    <img src="styles/legend/IKLHKab2023_1_1.png" /> Baik<br />\
    <img src="styles/legend/IKLHKab2023_1_2.png" /> Sedang<br />\
    <img src="styles/legend/IKLHKab2023_1_3.png" /> Cukup<br />\
    <img src="styles/legend/IKLHKab2023_1_4.png" /> Kurang<br />'
        });
var format_IKLHKab2022_2 = new ol.format.GeoJSON();
var features_IKLHKab2022_2 = format_IKLHKab2022_2.readFeatures(json_IKLHKab2022_2, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_IKLHKab2022_2 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_IKLHKab2022_2.addFeatures(features_IKLHKab2022_2);
var lyr_IKLHKab2022_2 = new ol.layer.Vector({
                declutter: false,
                source:jsonSource_IKLHKab2022_2, 
                style: style_IKLHKab2022_2,
                popuplayertitle: "IKLH Kab 2022",
                interactive: true,
    title: 'IKLH Kab 2022<br />\
    <img src="styles/legend/IKLHKab2022_2_0.png" /> Sangat Baik<br />\
    <img src="styles/legend/IKLHKab2022_2_1.png" /> Baik<br />\
    <img src="styles/legend/IKLHKab2022_2_2.png" /> Sedang<br />\
    <img src="styles/legend/IKLHKab2022_2_3.png" /> Cukup<br />\
    <img src="styles/legend/IKLHKab2022_2_4.png" /> Kurang<br />'
        });
var format_IKLHKab2021_3 = new ol.format.GeoJSON();
var features_IKLHKab2021_3 = format_IKLHKab2021_3.readFeatures(json_IKLHKab2021_3, 
            {dataProjection: 'EPSG:4326', featureProjection: 'EPSG:3857'});
var jsonSource_IKLHKab2021_3 = new ol.source.Vector({
    attributions: ' ',
});
jsonSource_IKLHKab2021_3.addFeatures(features_IKLHKab2021_3);
var lyr_IKLHKab2021_3 = new ol.layer.Vector({
                declutter: false,
                source:jsonSource_IKLHKab2021_3, 
                style: style_IKLHKab2021_3,
                popuplayertitle: "IKLH Kab 2021",
                interactive: true,
    title: 'IKLH Kab 2021<br />\
    <img src="styles/legend/IKLHKab2021_3_0.png" /> Sangat Baik<br />\
    <img src="styles/legend/IKLHKab2021_3_1.png" /> Baik<br />\
    <img src="styles/legend/IKLHKab2021_3_2.png" /> Sedang<br />\
    <img src="styles/legend/IKLHKab2021_3_3.png" /> Cukup<br />\
    <img src="styles/legend/IKLHKab2021_3_4.png" /> Kurang<br />'
        });

lyr_GoogleHybrid_0.setVisible(true);lyr_IKLHKab2023_1.setVisible(true);lyr_IKLHKab2022_2.setVisible(true);lyr_IKLHKab2021_3.setVisible(true);
var layersList = [lyr_GoogleHybrid_0,lyr_IKLHKab2023_1,lyr_IKLHKab2022_2,lyr_IKLHKab2021_3];
lyr_IKLHKab2023_1.set('fieldAliases', {'PROVNO': 'PROVNO', 'KABKOTNO': 'KABKOTNO', 'PROVINSI': 'PROVINSI', 'KABKOT': 'KABKOT', 'IDKAB': 'IDKAB', 'TAHUN': 'TAHUN', 'SUMBER': 'SUMBER', 'AOD_2023': 'AOD_2023', 'NO2_2023': 'NO2_2023', 'CO_2023': 'CO_2023', 'SO2_2023': 'SO2_2023', 'NDVI_2023': 'NDVI_2023', 'NTL_2023': 'NTL_2023', 'LST_2023': 'LST_2023', 'TSS_2023': 'TSS_2023', 'IKL_2023': 'IKL_2023', });
lyr_IKLHKab2022_2.set('fieldAliases', {'PROVNO': 'PROVNO', 'KABKOTNO': 'KABKOTNO', 'PROVINSI': 'PROVINSI', 'KABKOT': 'KABKOT', 'IDKAB': 'IDKAB', 'TAHUN': 'TAHUN', 'SUMBER': 'SUMBER', 'AOD_2022': 'AOD_2022', 'NO2_2022': 'NO2_2022', 'CO_2022': 'CO_2022', 'SO2_2022': 'SO2_2022', 'NDVI_2022': 'NDVI_2022', 'NTL_2022': 'NTL_2022', 'LST_2022': 'LST_2022', 'TSS_2022': 'TSS_2022', 'IKL_2022': 'IKL_2022', });
lyr_IKLHKab2021_3.set('fieldAliases', {'PROVNO': 'PROVNO', 'KABKOTNO': 'KABKOTNO', 'PROVINSI': 'PROVINSI', 'KABKOT': 'KABKOT', 'IDKAB': 'IDKAB', 'TAHUN': 'TAHUN', 'SUMBER': 'SUMBER', 'AOD_2021': 'AOD_2021', 'NO2_2021': 'NO2_2021', 'CO_2021': 'CO_2021', 'SO2_2021': 'SO2_2021', 'NDVI_2021': 'NDVI_2021', 'NTL_2021': 'NTL_2021', 'LST_2021': 'LST_2021', 'TSS_2021': 'TSS_2021', 'IKL_2021': 'IKL_2021', });
lyr_IKLHKab2023_1.set('fieldImages', {'PROVNO': 'TextEdit', 'KABKOTNO': 'TextEdit', 'PROVINSI': 'TextEdit', 'KABKOT': 'TextEdit', 'IDKAB': 'TextEdit', 'TAHUN': 'TextEdit', 'SUMBER': 'TextEdit', 'AOD_2023': 'TextEdit', 'NO2_2023': 'TextEdit', 'CO_2023': 'TextEdit', 'SO2_2023': 'TextEdit', 'NDVI_2023': 'TextEdit', 'NTL_2023': 'TextEdit', 'LST_2023': 'TextEdit', 'TSS_2023': 'TextEdit', 'IKL_2023': 'TextEdit', });
lyr_IKLHKab2022_2.set('fieldImages', {'PROVNO': 'TextEdit', 'KABKOTNO': 'TextEdit', 'PROVINSI': 'TextEdit', 'KABKOT': 'TextEdit', 'IDKAB': 'TextEdit', 'TAHUN': 'TextEdit', 'SUMBER': 'TextEdit', 'AOD_2022': 'TextEdit', 'NO2_2022': 'TextEdit', 'CO_2022': 'TextEdit', 'SO2_2022': 'TextEdit', 'NDVI_2022': 'TextEdit', 'NTL_2022': 'TextEdit', 'LST_2022': 'TextEdit', 'TSS_2022': 'TextEdit', 'IKL_2022': 'TextEdit', });
lyr_IKLHKab2021_3.set('fieldImages', {'PROVNO': 'TextEdit', 'KABKOTNO': 'TextEdit', 'PROVINSI': 'TextEdit', 'KABKOT': 'TextEdit', 'IDKAB': 'TextEdit', 'TAHUN': 'TextEdit', 'SUMBER': 'TextEdit', 'AOD_2021': 'TextEdit', 'NO2_2021': 'TextEdit', 'CO_2021': 'TextEdit', 'SO2_2021': 'TextEdit', 'NDVI_2021': 'TextEdit', 'NTL_2021': 'TextEdit', 'LST_2021': 'TextEdit', 'TSS_2021': 'TextEdit', 'IKL_2021': 'TextEdit', });
lyr_IKLHKab2023_1.set('fieldLabels', {'PROVNO': 'hidden field', 'KABKOTNO': 'hidden field', 'PROVINSI': 'hidden field', 'KABKOT': 'inline label - visible with data', 'IDKAB': 'hidden field', 'TAHUN': 'hidden field', 'SUMBER': 'hidden field', 'AOD_2023': 'inline label - visible with data', 'NO2_2023': 'inline label - visible with data', 'CO_2023': 'inline label - visible with data', 'SO2_2023': 'inline label - visible with data', 'NDVI_2023': 'inline label - visible with data', 'NTL_2023': 'inline label - visible with data', 'LST_2023': 'inline label - visible with data', 'TSS_2023': 'inline label - visible with data', 'IKL_2023': 'inline label - visible with data', });
lyr_IKLHKab2022_2.set('fieldLabels', {'PROVNO': 'hidden field', 'KABKOTNO': 'hidden field', 'PROVINSI': 'hidden field', 'KABKOT': 'inline label - visible with data', 'IDKAB': 'hidden field', 'TAHUN': 'hidden field', 'SUMBER': 'hidden field', 'AOD_2022': 'inline label - visible with data', 'NO2_2022': 'inline label - visible with data', 'CO_2022': 'inline label - visible with data', 'SO2_2022': 'inline label - visible with data', 'NDVI_2022': 'inline label - visible with data', 'NTL_2022': 'inline label - visible with data', 'LST_2022': 'inline label - visible with data', 'TSS_2022': 'inline label - visible with data', 'IKL_2022': 'inline label - visible with data', });
lyr_IKLHKab2021_3.set('fieldLabels', {'PROVNO': 'hidden field', 'KABKOTNO': 'hidden field', 'PROVINSI': 'hidden field', 'KABKOT': 'inline label - visible with data', 'IDKAB': 'hidden field', 'TAHUN': 'hidden field', 'SUMBER': 'hidden field', 'AOD_2021': 'inline label - visible with data', 'NO2_2021': 'inline label - visible with data', 'CO_2021': 'inline label - visible with data', 'SO2_2021': 'inline label - visible with data', 'NDVI_2021': 'inline label - visible with data', 'NTL_2021': 'inline label - visible with data', 'LST_2021': 'inline label - visible with data', 'TSS_2021': 'inline label - visible with data', 'IKL_2021': 'inline label - visible with data', });
lyr_IKLHKab2021_3.on('precompose', function(evt) {
    evt.context.globalCompositeOperation = 'normal';
});