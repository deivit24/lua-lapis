<template>
  <v-dialog width="400px" persistent v-model="reportDialog">
    <v-form ref="form" v-model="valid" lazy-validation>
      <v-card flat>
        <v-card-title> {{ name }}</v-card-title>
        <v-card-text class="pb-0">
          <v-select
            outlined
            :items="items"
            v-model="reportType"
            placeholder="Report Type *"
            :rules="[rules.required]"
          ></v-select>
          <v-textarea
            counter
            maxlength="255"
            v-model="report"
            outlined
            placeholder="Elaborate if necessary"
          >
          </v-textarea>
        </v-card-text>
        <v-card-actions class="justify-end">
          <v-btn
            text
            small
            color="default"
            @click="
              $emit('close');
              report = '';
              reportType = null;
            "
            >[ Cancel ]</v-btn
          >
          <v-btn
            text
            small
            color="error"
            :disabled="!valid"
            @click="
              submitReport(reportType, report);
              report = '';
            "
            >[ Report ]</v-btn
          >
        </v-card-actions>
      </v-card>
    </v-form>
  </v-dialog>
</template>

<script>
export default {
  name: "ReportDialog",
  props: {
    name: {
      type: String,
      default: "Report",
    },
    dialog: {
      type: Boolean,
      required: true,
    },
  },
  data: () => ({
    reportDialog: false,
    valid: false,
    report: "",
    rules: {
      required: (value) => !!value || "Required.",
    },
    reportType: null,
    items: [
      "Offensive Name",
      "Inapropriate Content",
      "Broke Rules",
      "Not tagged as 'Lewd'",
      "Other",
    ],
  }),
  watch: {
    dialog(val) {
      this.reportDialog = val;
    },
  },
  methods: {
    submitReport(reportType, report) {
      this.$emit("send", reportType, report);
      this.report = "";
      this.reportType = null;
    },
  },
};
</script>

<style></style>
