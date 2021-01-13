<template>
  <div v-if="isVisible && data && data.length > 1" class="right-floated mt-30m">
    <!-- button only csv if is table or recap -->
    <sui-button
      v-if="type === 'table' || type === 'recap' || type === 'rank'"
      @click="exportToCSV()"
      class="custom-btn"
      basic
      :content="$t('command.export_csv')"
      icon="download"
    />
    <!-- dropdown for csv and pdf export -->
    <sui-dropdown
      v-else
      class="icon basic"
      :class="{ transparent: transparent }"
      icon="download"
      button
      pointing="top right"
    >
      {{ $t("command.export") }}
      <sui-dropdown-menu>
        <sui-dropdown-item @click="exportToCSV()">{{ $t("command.export_csv") }}</sui-dropdown-item>
        <sui-dropdown-item v-if="isPdf" @click="exportToPDF('canvas')">{{ $t("command.export_pdf") }}
        </sui-dropdown-item>
      </sui-dropdown-menu>
    </sui-dropdown>
  </div>
</template>

<script>

import Papa from "papaparse";
import { jsPDF } from "jspdf";
import html2canvas from 'html2canvas';
import UtilService from "../services/utils";

export default {
  name: "ExportData",
  mixins: [UtilService],
  props: [
    "visible",
    "pdf",
    "transparent",
    "data",
    "filename",
    "pdfElementContainerId",
    "pdfElementHeaderClass",
    "type"
  ],
  data: function() {
    return {
      isVisible: this.visible || true,
      isPdf: this.pdf || true,
      parsedName: this.parseName(this.filename || "report")
    };
  },
  methods: {
    exportToCSV () {
      let data = this._.cloneDeep(this.data)
      // if 'src£phoneNumber' / 'dst£phoneNumber' columns are present, generate 'srcDevice' / 'dstDevice' columns
      data = this.checkDeviceColumns(data);
      // translate col labels
      for (let key in data[0]) data[0][key] = this.$t(this.parseColHeader(data[0][key]))
      // convert data obj to csv
      let blob = new Blob([Papa.unparse(data)], { type: 'text/csv;charset=utf-8;' }),
          link = document.createElement("a"),
          url = URL.createObjectURL(blob)
      link.setAttribute("href", url)
      link.setAttribute("download", `${this.parsedName}.csv`)
      link.style.visibility = 'hidden'
      document.body.appendChild(link)
      // download csv
      link.click();
      document.body.removeChild(link)
      data = null
    },
    async exportToPDF (elementTag, options = {}) {
      if (!this.pdfElementContainerId) return
      // get the element height/width
      let element = document.querySelector(`${this.pdfElementContainerId} ${elementTag}`),
          header = document.querySelector(`${this.pdfElementContainerId} ${this.pdfElementHeaderClass}`),
          elementHeight = element.offsetHeight,
          elementWidth = element.offsetWidth,
          orizontalMargins = options.margin || 100,
          marginTop = options.top || 70,
          marginBottom = options.bottom || 20
      // create partial canvas
      let pdfCanvas = document.createElement("canvas")
      pdfCanvas.setAttribute("id", "canvaspdf")
      pdfCanvas.setAttribute("width", elementWidth + (orizontalMargins * 2))
      pdfCanvas.setAttribute("height", elementHeight + marginTop)
      // keep track canvas position
      let pdfctx = pdfCanvas.getContext('2d'),
          pdfctxX = orizontalMargins,
          pdfctxY = marginTop
      // create new pdf and add our new canvas as an image
      let pdf = new jsPDF({
        orientation: 'l',
        unit: 'pt',
        format: [(elementWidth + orizontalMargins * 2) * 0.75 , (elementHeight + marginTop + marginBottom) * 0.75],
        compress:true
      })
      // add header html header to pdf
      await html2canvas(header).then(function(canvas) {
        pdf.addImage(canvas, 'PNG', (((elementWidth + orizontalMargins * 2) - header.offsetWidth) * 0.75) / 2, 20)
      }),
      // draw imange into the new canvas
      pdfctx.drawImage(element, pdfctxX, pdfctxY, elementWidth, elementHeight)
      // add canvas to pdf
      pdf.addImage(pdfCanvas, 'PNG', 0, 0)
      // download the pdf
      pdf.save(`${this.parsedName}.pdf`);
    },
    parseName (filename) {
      return filename.toLowerCase().replace(/[\s.]+/g,'_')
    },
    parseColHeader (header) {
      let parsedHeader = this.parseTableChartHeader(header)
      let resHeader = parsedHeader.bottomHeaderName || parsedHeader.middleHeaderName || parsedHeader.topHeaderName
      return resHeader
    },
    checkDeviceColumns (data) {
      const columns = data[0];
      const srcPos = columns.indexOf("src£phoneNumber");
      const dstPos = columns.indexOf("dst£phoneNumber");

      if (srcPos > -1 && dstPos > -1) {
        // generate 'srcDevice' and 'dstDevice' columns
        // add new columns near src/dst (add right-most column first)

        if (srcPos < dstPos) {
          columns.splice(dstPos + 1, 0, "dstDevice");
          columns.splice(srcPos + 1, 0, "srcDevice");
        } else {
          columns.splice(srcPos + 1, 0, "srcDevice");
          columns.splice(dstPos + 1, 0, "dstDevice");
        }
        const rows = data.slice(1);

        for (const row of rows) {
          const srcElem = row[srcPos];
          const dstElem = row[dstPos];
          let srcDevice = "";
          let dstDevice = "";

          if (this.$root.devices[srcElem]) {
            srcDevice = this.$root.devices[srcElem].type;
          }

          if (this.$root.devices[dstElem]) {
            dstDevice = this.$root.devices[dstElem].type;
          }

          if (srcPos < dstPos) {
            row.splice(dstPos + 1, 0, dstDevice);
            row.splice(srcPos + 1, 0, srcDevice);
          } else {
            row.splice(srcPos + 1, 0, srcDevice);
            row.splice(dstPos + 1, 0, dstDevice);
          }
        }
      }
      return data;
    },
  },
  watch: {
    "filename": function () {
      this.parsedName = this.parseName(this.filename || "report")
    }
  },
}

</script>

<style lang="scss" scoped>
.transparent {
  padding: 2px !important;
  background: none !important;
  margin: 0px 7px !important;
  .menu {
    left: -9px !important;
  }
}
.custom-btn {
  padding: .78571429em .78571429em .78571429em !important;
  margin: 0 4px 0 0 !important;
  margin: 0px !important;
}
</style>