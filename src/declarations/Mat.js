const declarations = [
    ["class cv.Mat", "", ["/Simple", "/DC"], [
        ["int", "flags", "", ["/RW"]],
        ["int", "dims", "", ["/RW"]],
        ["int", "rows", "", ["/RW"]],
        ["int", "cols", "", ["/RW"]],
        ["uchar*", "data", "", ["/RW"]],
        ["size_t", "step", "", ["/RW"]],
        ["int", "width", "", ["/RW", "=cols"]],
        ["int", "height", "", ["/RW", "=rows"]]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["Size", "size", "", []],
        ["int", "type", "", []]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
        ["Scalar", "s", "", []],
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["Size", "size", "", []],
        ["int", "type", "", []],
        ["Scalar", "s", "", []],
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
        ["void*", "data", "", []],
        ["size_t", "step", "cv::Mat::AUTO_STEP", []]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["Mat", "m", "", []]
    ], "", ""],

    ["cv.Mat.Mat", "", [], [
        ["Mat", "src", "", []],
        ["Rect", "roi", "", []]
    ], "", ""],

    ["cv.Mat.row", "cv::Mat", [], [
        ["int", "y", "", []],
    ], "", ""],
    ["cv.Mat.col", "cv::Mat", [], [
        ["int", "x", "", []],
    ], "", ""],
    ["cv.Mat.rowRange", "cv::Mat", [], [
        ["int", "startrow", "", []],
        ["int", "endrow", "", []],
    ], "", ""],
    ["cv.Mat.rowRange", "cv::Mat", [], [
        ["Range", "r", "", []],
    ], "", ""],
    ["cv.Mat.colRange", "cv::Mat", [], [
        ["int", "startcol", "", []],
        ["int", "endcol", "", []],
    ], "", ""],
    ["cv.Mat.colRange", "cv::Mat", [], [
        ["Range", "r", "", []],
    ], "", ""],

    ["cv.Mat.isContinuous", "bool", [], [], "", ""],
    ["cv.Mat.isSubmatrix", "bool", [], [], "", ""],
    ["cv.Mat.elemSize", "size_t", [], [], "", ""],
    ["cv.Mat.elemSize1", "size_t", [], [], "", ""],

    ["cv.Mat.type", "int", [], [], "", ""],
    ["cv.Mat.depth", "int", [], [], "", ""],
    ["cv.Mat.channels", "int", [], [], "", ""],

    ["cv.Mat.step1", "size_t", [], [
        ["int", "i", "0", []]
    ], "", ""],

    ["cv.Mat.empty", "bool", [], [], "", ""],
    ["cv.Mat.total", "size_t", [], [], "", ""],
    ["cv.Mat.total", "size_t", [], [
        ["int", "startDim", "", []],
        ["int", "endDim", "INT_MAX", []],
    ], "", ""],

    ["cv.Mat.checkVector", "int", [], [
        ["int", "elemChannels", "", []],
        ["int", "depth", "-1", []],
        ["int", "requireContinuous", "true", []],
    ], "", ""],

    ["cv.Mat.ptr", "uchar*", [], [
        ["int", "y", "0", []]
    ], "", ""],
    ["cv.Mat.ptr", "uchar*", [], [
        ["int", "i0", "", []],
        ["int", "i1", "", []],
    ], "", ""],
    ["cv.Mat.ptr", "uchar*", [], [
        ["int", "i0", "", []],
        ["int", "i1", "", []],
        ["int", "i2", "", []],
    ], "", ""],

    ["cv.Mat.size", "Size", [], [], "", ""],
    ["cv.Mat.pop_back", "void", [], [
        ["size_t", "value", "", []]
    ], "", ""],
    ["cv.Mat.push_back", "void", [], [
        ["Mat", "value", "", []]
    ], "", ""],
    ["cv.Mat.clone", "Mat", [], [], "", ""],
    ["cv.Mat.clone", "Mat", ["=copy"], [], "", ""],
    ["cv.Mat.copyTo", "void", [], [
        ["OutputArray", "m", "", []],
    ], "", ""],
    ["cv.Mat.copyTo", "void", [], [
        ["OutputArray", "m", "", []],
        ["InputArray", "mask", "", []],
    ], "", ""],
    ["cv.Mat.setTo", "void", [], [
        ["InputArray", "value", "", []],
        ["InputArray", "mask", "noArray()", []],
    ], "", ""],
    ["cv.Mat.convertTo", "void", [], [
        ["OutputArray", "m", "", []],
        ["int", "rtype", "", []],
        ["double", "alpha", "1.0", []],
        ["double", "beta", "0.0", []],
    ], "", ""],
    ["cv.Mat.reshape", "cv::Mat", [], [
        ["int", "cn", "", []],
        ["int", "rows", "0", []],
    ], "", ""],
    ["cv.Mat.dot", "double", [], [
        ["InputArray", "m", "", []],
    ], "", ""],
    ["cv.Mat.cross", "Mat", [], [
        ["InputArray", "m", "", []],
    ], "", ""],
    ["cv.Mat.diag", "cv::Mat", [], [
        ["int", "d", "0", []],
    ], "", ""],
    ["cv.Mat.t", "cv::Mat", [], [], "", ""],

    ["cv.Mat.Point_at", "Point2d", ["/External"], [
        ["int", "x", "", []],
    ], "", ""],

    ["cv.Mat.Point_at", "Point2d", ["/External"], [
        ["int", "x", "", []],
        ["int", "y", "", []],
    ], "", ""],

    ["cv.Mat.Point_at", "Point2d", ["/External"], [
        ["Point", "pt", "", []],
    ], "", ""],

    ["cv.Mat.at", "double", ["/External"], [
        ["int", "x", "", []],
    ], "", ""],

    ["cv.Mat.set_at", "void", ["/External"], [
        ["int", "x", "", []],
        ["double", "value", "", []],
    ], "", ""],

    ["cv.Mat.at", "double", ["/External"], [
        ["int", "x", "", []],
        ["int", "y", "", []],
    ], "", ""],

    ["cv.Mat.set_at", "void", ["/External"], [
        ["int", "x", "", []],
        ["int", "y", "", []],
        ["double", "value", "", []],
    ], "", ""],

    ["cv.Mat.at", "double", ["/External"], [
        ["Point", "pt", "", []],
    ], "", ""],

    ["cv.Mat.set_at", "void", ["/External"], [
        ["Point", "pt", "", []],
        ["double", "value", "", []],
    ], "", ""],

    ["cv.Mat.eye", "cv::Mat", ["/S"], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.zeros", "cv::Mat", ["/S"], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.zeros", "cv::Mat", ["/S"], [
        ["Size", "size", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.ones", "cv::Mat", ["/S"], [
        ["int", "rows", "", []],
        ["int", "cols", "", []],
        ["int", "type", "", []],
    ], "", ""],

    ["cv.Mat.ones", "cv::Mat", ["/S"], [
        ["Size", "size", "", []],
        ["int", "type", "", []],
    ], "", ""],
];

const types = new Set(["int", "float", "double"]);

for (const _Tp of ["b", "s", "w"]) {
    for (const cn of [2, 3, 4]) { // eslint-disable-line no-magic-numbers
        types.add(`Vec${ cn }${ _Tp }`);
    }
}

for (const cn of [2, 3, 4, 6, 8]) { // eslint-disable-line no-magic-numbers
    types.add(`Vec${ cn }i`);
}

for (const _Tp of ["f", "d"]) {
    for (const cn of [2, 3, 4, 6]) { // eslint-disable-line no-magic-numbers
        types.add(`Vec${ cn }${ _Tp }`);
    }
}

for (const type of types) {
    if (type.startsWith("Vec")) {
        declarations.push(["cv.Mat.Mat", "", [`=createFrom${ type }`], [
            [type, "vec", "", []],
            ["bool", "copyData", "true", []],
        ], "", ""]);

        declarations.push(["cv.Mat.Mat", "", [`=createFromVectorOf${ type }`], [
            [`vector_${ type }`, "vec", "", []],
            ["bool", "copyData", "true", []],
        ], "", ""]);
    }

    declarations.push(...[
        [`cv.Mat.at<${ type }>`, type, [`=${ type }_at`], [
            ["int", "x", "", []],
        ], "", ""],

        [`cv.Mat.at<${ type }>`, "void", [`=${ type }_set_at`, "/Expr=(x) = value"], [
            ["int", "x", "", []],
            [type, "value", "", []],
        ], "", ""],

        [`cv.Mat.at<${ type }>`, type, [`=${ type }_at`], [
            ["int", "x", "", []],
            ["int", "y", "", []]
        ], "", ""],

        [`cv.Mat.at<${ type }>`, "void", [`=${ type }_set_at`, "/Expr=(x, y) = value"], [
            ["int", "x", "", []],
            ["int", "y", "", []],
            [type, "value", "", []],
        ], "", ""],

        [`cv.Mat.at<${ type }>`, type, [`=${ type }_at`], [
            ["Point", "pt", "", []],
        ], "", ""],

        [`cv.Mat.at<${ type }>`, "void", [`=${ type }_set_at`, "/Expr=(pt) = value"], [
            ["Point", "pt", "", []],
            [type, "value", "", []],
        ], "", ""],
    ]);
}

module.exports = declarations;
