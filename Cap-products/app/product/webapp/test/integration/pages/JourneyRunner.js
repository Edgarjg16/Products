sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"logaligroup/product/test/integration/pages/ProductsList.gen",
	"logaligroup/product/test/integration/pages/ProductsObjectPage.gen",
	"logaligroup/product/test/integration/pages/ReviewObjectPage.gen"
], function (JourneyRunner, ProductsListGenerated, ProductsObjectPageGenerated, ReviewObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('logaligroup/product') + '/test/flp.html#app-preview',
        pages: {
			onTheProductsListGenerated: ProductsListGenerated,
			onTheProductsObjectPageGenerated: ProductsObjectPageGenerated,
			onTheReviewObjectPageGenerated: ReviewObjectPageGenerated
        },
        async: true
    });

    return runner;
});

