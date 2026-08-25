// ============================================================
// Phase 2 (v1.10.0): 困境场景库 + 自定义困境模板
// ============================================================

///|
/// 困境模板
///
/// 支持变量插值的困境模板。模板文本中用 `{var_name}` 标记变量位置，
/// `instantiate` 时用实际值替换。
///
/// # Example
/// ```mbt check
/// test {
///   let t = @ghostvalley.DilemmaTemplate::new(
///     "收到{count}条差评，涉及{product}，如何处理？",
///     category="operational",
///     difficulty=2,
///   )
///   let d = t.instantiate([("count", "50"), ("product", "会员服务")])
///   assert_true(d.content.contains("50"))
/// }
/// ```
pub(all) struct DilemmaTemplate {
  template_text : String
  variables : Array[String]
  category : String
  difficulty : Int
} derive(Debug, ToJson, FromJson)

///|
pub extend DilemmaTemplate with @debug.Debug::{to_repr}

///|
pub extend DilemmaTemplate with ToJson::{to_json}

///|
pub extend DilemmaTemplate with FromJson::{from_json}

///|
/// 场景困境集合
///
/// 一个业务场景下的所有困境模板，按难度分组。
pub(all) struct ScenarioDilemmas {
  scenario_name : String
  templates : Array[DilemmaTemplate]
} derive(Debug, ToJson, FromJson)

///|
pub extend ScenarioDilemmas with @debug.Debug::{to_repr}

///|
pub extend ScenarioDilemmas with ToJson::{to_json}

///|
pub extend ScenarioDilemmas with FromJson::{from_json}

///|
/// 困境场景库
///
/// 管理多个业务场景的困境模板集合。
/// 支持注册自定义场景、按场景和难度检索困境、模板变量插值。
///
/// # Example
/// ```mbt check
/// test {
///   let lib = @ghostvalley.DilemmaLibrary::with_presets()
///   let scenarios = lib.list_scenarios()
///   assert_true(scenarios.length() >= 5)
/// }
/// ```
pub(all) struct DilemmaLibrary {
  scenarios : Array[ScenarioDilemmas]
} derive(Debug, ToJson, FromJson)

///|
pub extend DilemmaLibrary with @debug.Debug::{to_repr}

///|
pub extend DilemmaLibrary with ToJson::{to_json}

///|
pub extend DilemmaLibrary with FromJson::{from_json}

///|
/// 创建困境模板
pub fn DilemmaTemplate::new(
  template_text : String,
  category~ : String,
  difficulty~ : Int,
) -> DilemmaTemplate {
  // 自动提取 {var} 格式的变量名
  let vars = extract_template_vars(template_text)
  { template_text, variables: vars, category, difficulty }
}

///|
/// 实例化模板
///
/// 将模板中的 `{var_name}` 替换为实际值，生成具体困境。
/// 未提供值的变量保留原样。
pub fn DilemmaTemplate::instantiate(
  self : DilemmaTemplate,
  bindings : Array[(String, String)],
) -> Dilemma {
  let mut result = self.template_text
  for pair in bindings {
    let (var, val) = pair
    let placeholder = "{" + var + "}"
    result = result.replace(old=placeholder, new=val)
  }
  Dilemma::new(result, category=self.category, difficulty=self.difficulty)
}

///|
/// 提取模板变量名
///
/// 从 `{var_name}` 格式中提取变量名列表。
fn extract_template_vars(text : String) -> Array[String] {
  let vars : Array[String] = []
  let chars = text.to_array()
  let mut i = 0
  let mut in_brace = false
  let mut current = StringBuilder::new()
  while i < chars.length() {
    let c = chars[i]
    if c == '{' {
      in_brace = true
      current = StringBuilder::new()
    } else if c == '}' && in_brace {
      in_brace = false
      let name = current.to_string()
      if name.length() > 0 {
        vars.push(name)
      }
    } else if in_brace {
      current.write_char(c)
    }
    i = i + 1
  }
  vars
}

///|
/// 创建空场景库
pub fn DilemmaLibrary::new() -> DilemmaLibrary {
  { scenarios: [] }
}

///|
/// 创建包含预置场景的场景库
///
/// 预置 5 个业务场景：客服危机、项目延期、团队冲突、技术选型失误、安全事故复盘。
pub fn DilemmaLibrary::with_presets() -> DilemmaLibrary {
  let lib = DilemmaLibrary::new()
  lib.register_scenario("客服危机", customer_service_dilemmas())
  lib.register_scenario("项目延期", project_delay_dilemmas())
  lib.register_scenario("团队冲突", team_conflict_dilemmas())
  lib.register_scenario("技术选型失误", tech_choice_dilemmas())
  lib.register_scenario("安全事故复盘", safety_incident_dilemmas())
  lib
}

///|
/// 注册场景
///
/// 向场景库添加一个业务场景及其困境模板集合。
pub fn DilemmaLibrary::register_scenario(
  self : DilemmaLibrary,
  name : String,
  templates : Array[DilemmaTemplate],
) -> Unit {
  self.scenarios.push(ScenarioDilemmas::{ scenario_name: name, templates })
}

///|
/// 列出所有场景名
pub fn DilemmaLibrary::list_scenarios(self : DilemmaLibrary) -> Array[String] {
  let result : Array[String] = []
  for s in self.scenarios {
    result.push(s.scenario_name)
  }
  result
}

///|
/// 从指定场景指定难度取困境
///
/// 返回该场景下所有匹配难度的困境。若场景不存在返回空数组。
pub fn DilemmaLibrary::get_dilemmas(
  self : DilemmaLibrary,
  scenario : String,
  difficulty : Int,
) -> Array[Dilemma] {
  let result : Array[Dilemma] = []
  for s in self.scenarios {
    if s.scenario_name == scenario {
      for t in s.templates {
        if t.difficulty == difficulty {
          result.push(
            Dilemma::new(
              t.template_text,
              category=t.category,
              difficulty=t.difficulty,
            ),
          )
        }
      }
    }
  }
  result
}

///|
/// 从指定场景取所有困境模板
pub fn DilemmaLibrary::get_all_templates(
  self : DilemmaLibrary,
  scenario : String,
) -> Array[DilemmaTemplate] {
  for s in self.scenarios {
    if s.scenario_name == scenario {
      return s.templates
    }
  }
  []
}

///|
/// 场景数量
pub fn DilemmaLibrary::scenario_count(self : DilemmaLibrary) -> Int {
  self.scenarios.length()
}

///|
/// 总模板数
pub fn DilemmaLibrary::total_templates(self : DilemmaLibrary) -> Int {
  let mut count = 0
  for s in self.scenarios {
    count = count + s.templates.length()
  }
  count
}

///|
/// 格式化场景库概览
pub fn DilemmaLibrary::format(self : DilemmaLibrary) -> String {
  let buf = StringBuilder::new()
  buf.write_string("=== 困境场景库 ===\n")
  for s in self.scenarios {
    buf.write_string("【")
    buf.write_string(s.scenario_name)
    buf.write_string("】")
    buf.write_string(s.templates.length().to_string())
    buf.write_string("个困境\n")
    for t in s.templates {
      buf.write_string("  难度")
      buf.write_string(t.difficulty.to_string())
      buf.write_string(" [")
      buf.write_string(t.category)
      buf.write_string("] ")
      buf.write_string(t.template_text)
      buf.write_string("\n")
    }
  }
  buf.to_string()
}

// ============================================================
// 预置业务场景困境库
// ============================================================

///|
/// 客服危机场景困境
fn customer_service_dilemmas() -> Array[DilemmaTemplate] {
  [
    DilemmaTemplate::new(
      "收到{count}条差评集中投诉{product}，客服团队情绪低落，如何应对？",
      category="emotional",
      difficulty=1,
    ),
    DilemmaTemplate::new(
      "用户在社交媒体公开指责{product}质量问题，引发{count}条转发，公关和客服如何协同？",
      category="social",
      difficulty=2,
    ),
    DilemmaTemplate::new(
      "恶意用户批量发起{count}次退款申请并威胁曝光，如何区分真实诉求与恶意攻击？",
      category="cognitive",
      difficulty=3,
    ),
    DilemmaTemplate::new(
      "客服系统宕机{duration}，积压{count}条未处理工单，如何优先排序处理？",
      category="operational",
      difficulty=2,
    ),
    DilemmaTemplate::new(
      "VIP客户投诉处理结果不满意，威胁终止合作并带走{count}个企业客户，如何挽回？",
      category="emotional",
      difficulty=3,
    ),
  ]
}

///|
/// 项目延期场景困境
fn project_delay_dilemmas() -> Array[DilemmaTemplate] {
  [
    DilemmaTemplate::new(
      "项目已延期{days}天，客户催促交付，团队加班疲劳严重，如何平衡进度与质量？",
      category="operational",
      difficulty=1,
    ),
    DilemmaTemplate::new(
      "关键路径上的{module}模块开发受阻，依赖团队无法按时交付，如何调整计划？",
      category="cognitive",
      difficulty=2,
    ),
    DilemmaTemplate::new(
      "项目延期{days}天后客户要求赔偿{amount}，同时内部对责任归属产生分歧，如何处理？",
      category="social",
      difficulty=3,
    ),
    DilemmaTemplate::new(
      "距离交付仅剩{days}天，测试发现{count}个严重缺陷，是否延期修复还是带病上线？",
      category="cognitive",
      difficulty=3,
    ),
    DilemmaTemplate::new(
      "项目经理因病请假{days}天，无人接管项目状态，团队士气低落，如何维持运转？",
      category="emotional",
      difficulty=2,
    ),
  ]
}

///|
/// 团队冲突场景困境
fn team_conflict_dilemmas() -> Array[DilemmaTemplate] {
  [
    DilemmaTemplate::new(
      "两名核心成员因技术方案产生激烈争执，各自拒绝妥协，如何调解？",
      category="social",
      difficulty=1,
    ),
    DilemmaTemplate::new(
      "团队分裂为两派支持不同架构方向，沟通陷入僵局，如何引导达成共识？",
      category="social",
      difficulty=2,
    ),
    DilemmaTemplate::new(
      "资深成员公开质疑新任技术负责人的决策，团队信任出现裂痕，如何重建权威？",
      category="emotional",
      difficulty=3,
    ),
    DilemmaTemplate::new(
      "跨部门协作中对方团队反复推诿责任，导致项目停滞{days}天，如何破局？",
      category="operational",
      difficulty=2,
    ),
    DilemmaTemplate::new(
      "团队中有人散播负面情绪影响{count}名成员，如何在不撕破脸的情况下处理？",
      category="emotional",
      difficulty=3,
    ),
  ]
}

///|
/// 技术选型失误场景困境
fn tech_choice_dilemmas() -> Array[DilemmaTemplate] {
  [
    DilemmaTemplate::new(
      "选用的{tech}框架在生产环境暴露严重性能问题，是否推倒重来？",
      category="cognitive",
      difficulty=1,
    ),
    DilemmaTemplate::new(
      "技术选型失误导致{count}个模块需要重写，预估{days}人天工作量，如何向管理层汇报？",
      category="social",
      difficulty=2,
    ),
    DilemmaTemplate::new(
      "坚持原选型需要{days}天修复，切换新选型需要{days}天重写，两条路都有风险，如何决策？",
      category="cognitive",
      difficulty=3,
    ),
    DilemmaTemplate::new(
      "选型失误被竞争对手利用做市场宣传，如何技术止损的同时控制公关影响？",
      category="operational",
      difficulty=3,
    ),
    DilemmaTemplate::new(
      "团队对推翻原选型意见不一，部分成员已基于原选型完成开发，如何平衡沉没成本？",
      category="emotional",
      difficulty=2,
    ),
  ]
}

///|
/// 安全事故复盘场景困境
fn safety_incident_dilemmas() -> Array[DilemmaTemplate] {
  [
    DilemmaTemplate::new(
      "生产环境发生{level}级安全事故，影响{count}用户，如何第一时间响应？",
      category="operational",
      difficulty=1,
    ),
    DilemmaTemplate::new(
      "事故根因指向团队成员的操作失误，如何在不追责的前提下改进流程？",
      category="emotional",
      difficulty=2,
    ),
    DilemmaTemplate::new(
      "安全事故造成{amount}经济损失，监管要求{days}天内提交整改报告，如何组织复盘？",
      category="social",
      difficulty=3,
    ),
    DilemmaTemplate::new(
      "事故暴露出安全审计流程形同虚设，如何在不否定过往工作的前提下重建体系？",
      category="cognitive",
      difficulty=2,
    ),
    DilemmaTemplate::new(
      "同类事故在{count}个月内重复发生{count}次，管理层要求一次性根治，如何回应？",
      category="cognitive",
      difficulty=3,
    ),
  ]
}
