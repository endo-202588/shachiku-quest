import { application } from "controllers/application";

// importmap に pin されている controllers/**/*_controller を一括で読み込む
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);
